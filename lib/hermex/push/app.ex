defmodule Hermex.Push.App do
  use Ecto.Schema
  import Ecto.Changeset

  schema "apps" do
    field :platform, :string
    field :name, :string
    field :settings, :map

    has_many :devices, Hermex.Push.Device

    timestamps()
  end

  @required_fields ~w(platform name settings)a
  @optional_fields ~w()a

  @gcm_required_fields ~w(auth_key)
  @apns_required_fields ~w(cert key)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:platform, ~w(gcm apns))
    |> validate_settings()
    |> normalize_settings()
    |> unique_constraint(:name, name: :apps_name_platform_index)
  end

  defp validate_settings(changeset) do
    with true <- changeset.valid?,
         settings when not is_nil(settings) <- get_change(changeset, :settings),
         platform when not is_nil(platform) <- get_change(changeset, :platform) do
      validate_settings(changeset, String.to_atom(platform))
    else
      _ -> changeset
    end
  end

  defp normalize_settings(changeset) do
    changeset
    |> crlf_to_lf(:cert)
    |> crlf_to_lf(:key)
  end

  defp crlf_to_lf(changeset, key) do
    case get_change(changeset, :settings, %{}) do
      %{^key => value} = settings when is_binary(value) ->
        new_value = String.replace(value, "\r\n", "\n")
        put_change(changeset, :settings, Map.put(settings, key, new_value))
      _ -> changeset
    end
  end

  defp validate_settings(changeset, :gcm) do
    check_settings(changeset, @gcm_required_fields)
  end

  defp validate_settings(changeset, :apns) do
    check_settings(changeset, @apns_required_fields)
  end

  defp check_settings(changeset, required_fields) do
    settings = get_change(changeset, :settings)
    changeset_keys = settings |> Map.keys() |> Enum.map(&to_string(&1))
    missing_keys = required_fields -- changeset_keys
    if Enum.empty?(missing_keys) do
      changeset
    else
      add_error(changeset, :settings, "missing keys #{inspect(missing_keys)}")
    end
  end

  def sensible_settings do
    ~w(auth_key key cert)
  end
end
