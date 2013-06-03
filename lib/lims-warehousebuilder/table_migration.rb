module Lims::WarehouseBuilder
  module TableMigration

    # @param [Sequel::Model] object_class
    def maintain_warehouse_for(object_class)
      maintain_currency_triggers(object_class.table_name, object_class.columns)
    end

    private

    # TODO: use a method like active record quote_table_name
    # @param [Symbol] table
    # @param [Array] columns
    # Update the trigger on the table *table* so the current table
    # schema is always up to date with the historic schema.
    def maintain_currency_triggers(table, columns)
      current_table = "current_#{table.to_s.sub(/^[^_]*_/, '')}"
      new_values = columns.map { |c| "NEW.#{c}" }.join(',')
      
      drop_trigger("maintain_#{current_table}_trigger") 
      after_trigger(
        %Q{
        BEGIN
        DELETE FROM #{current_table} WHERE uuid = NEW.uuid;
        INSERT INTO #{current_table}(#{columns.join(',')}) VALUES(#{new_values});
        END
        },
          :name => "maintain_#{current_table}_trigger",
          :event => :insert,
          :on => table)
    end

    # TODO: extract the sql request and put it in a mysql2 adapter file
    module Trigger
      def drop_trigger(name)
        DB.run "DROP TRIGGER IF EXISTS #{name}" 
      end

      def after_trigger(code, details)
        create_trigger(:after, code, details)
      end

      def create_trigger(at, code, details)
        DB.run "CREATE TRIGGER #{details[:name]} #{at.to_s.upcase} #{details[:event].to_s.upcase} ON #{details[:on]} FOR EACH ROW #{code}"
      end
      private :create_trigger
    end
    include Trigger

  end
end

