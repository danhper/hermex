defmodule BuildyPush.App do
  use BuildyPush.Web, :model

  schema "apps" do
    field :platform, :string
    field :name, :string
    field :settings, :map

    has_many :devices, BuildyPush.Device

    timestamps
  end

  @required_fields ~w(platform name settings)
  @optional_fields ~w()

  @gcm_required_fields ~w(auth_key)
  @apns_required_fields ~w(cert key)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:platform, ~w(gcm apns))
    |> validate_settings
    |> unique_constraint(:name, name: :apps_name_platform_index)
  end

  defp validate_settings(changeset) do
    if changeset.valid? &&
         get_change(changeset, :settings) &&
        (platform = get_change(changeset, :platform)) do
      validate_settings(changeset, String.to_atom(platform))
    else
      changeset
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
    missing_keys = required_fields -- Map.keys(settings)
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
