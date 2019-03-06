class CreateExceptionLoggers < ActiveRecord::Migration[5.1]
  def change
    create_table :exception_loggers do |t|
      t.text :message
      t.string :source
      t.string :params

      t.timestamps
    end
  end
end
