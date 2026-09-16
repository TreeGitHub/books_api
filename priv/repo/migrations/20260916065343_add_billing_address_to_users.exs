defmodule BooksApi.Repo.Migrations.AddBillingAddressToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:billing_address, :string)
    end
  end
end
