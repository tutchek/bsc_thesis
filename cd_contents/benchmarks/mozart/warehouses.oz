functor
import
	FD
	Space
	Search
	System
	Application
	Property
define
fun {Warehouses Data}
   
   fun {Regret X}
      M = {FD.reflect.min X}
   in
      {FD.reflect.nextLarger X M} - M
   end

   NbStores = {Width Data.costs}
   NbWarehouses = {Width Data.capacity}
   Capacity = Data.capacity
   WarehouseCost = Data.warehouseCost
   CostMatrix = Data.costs
   
in
   proc {$ Sol}
      TotalCost = {FD.decl}
      Open = {FD.tuple warehouse 5 0#1}
      Supplier = {FD.tuple supplier NbStores 1#NbWarehouses}

      Cost = {FD.tuple store NbStores 0#FD.sup}
      SumCost = {FD.decl} = {FD.sum Cost '=:'}

      Stores = {List.number 1 NbStores 1}

      NbOpen = {FD.decl} = {FD.sum Open '=:'}
   in
      Sol = plan(totalCost:TotalCost open:Open supplier:Supplier)

      TotalCost =: SumCost + NbOpen * WarehouseCost

      {For 1 NbStores 1
       proc {$ Store}
	  Cost.Store :: {Record.toList CostMatrix.Store}
	  {FD.element Supplier.Store CostMatrix.Store Cost.Store}
       end}

      {For 1 NbWarehouses 1
       proc {$ Warehouse}
	  {FD.atMost Capacity.Warehouse Supplier Warehouse}
	  Open.Warehouse = {FD.reified.sum {Map Stores fun {$ Store} Supplier.Store =: Warehouse end} '>:' 0}
       end}
      
      {FD.distribute ff Supplier}
   end
end

proc {Order Old New}
   Old.totalCost >: New.totalCost
end


Data = company(
	  warehouseCost:50
	  capacity:wh(1 4 2 1 3)
	  costs:stores(
		  wh(36 42 22 44 52)
		  wh( 49 47 134 135 121 )
		  wh( 121 158 117 156 115 )
		  wh( 8 91 120 113 101 )
		  wh( 77 156 98 135 11 )
		  wh( 71 39 50 110 98 )
		  wh( 6 12 120 98 93 )
		  wh( 20 120 25 72 156 )
		  wh( 151 60 104 139 77 )
		  wh( 79 107 91 117 154 )
		 )
	  )

in

	{Property.put 'print.width' 1000}
	{Property.put 'print.depth' 1000}

	{System.show {Search.base.best {Warehouses Data} Order}}
	
	{Application.exit 0}
end