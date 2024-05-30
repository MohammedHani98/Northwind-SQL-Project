if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Orders') and o.name = 'FK_ORDER_REFERENCE_CUSTOMER')
alter table Orders
   drop constraint FK_ORDER_REFERENCE_CUSTOMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('OrderItems') and o.name = 'FK_ORDERITE_REFERENCE_ORDER')
alter table OrderItems
   drop constraint FK_ORDERITE_REFERENCE_ORDER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('OrderItems') and o.name = 'FK_ORDERITE_REFERENCE_PRODUCT')
alter table OrderItems
   drop constraint FK_ORDERITE_REFERENCE_PRODUCT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Products') and o.name = 'FK_PRODUCT_REFERENCE_SUPPLIER')
alter table Products
   drop constraint FK_PRODUCT_REFERENCE_SUPPLIER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Customers')
            and   name  = 'IndexCustomerName'
            and   indid > 0
            and   indid < 255)
   drop index Customers.IndexCustomerName
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Customers')
            and   type = 'U')
   drop table Customers
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Orders')
            and   name  = 'IndexOrderOrderDate'
            and   indid > 0
            and   indid < 255)
   drop index Orders.IndexOrderOrderDate
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Orders')
            and   name  = 'IndexOrderCustomerId'
            and   indid > 0
            and   indid < 255)
   drop index Orders.IndexOrderCustomerId
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Orders')
            and   type = 'U')
   drop table Orders
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('OrderItems')
            and   name  = 'IndexOrderItemProductId'
            and   indid > 0
            and   indid < 255)
   drop index OrderItems.IndexOrderItemProductId
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('OrderItems')
            and   name  = 'IndexOrderItemOrderId'
            and   indid > 0
            and   indid < 255)
   drop index OrderItems.IndexOrderItemOrderId
go

if exists (select 1
            from  sysobjects
           where  id = object_id('OrderItems')
            and   type = 'U')
   drop table OrderItems
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Products')
            and   name  = 'IndexProductName'
            and   indid > 0
            and   indid < 255)
   drop index Products.IndexProductName
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Products')
            and   name  = 'IndexProductSupplierId'
            and   indid > 0
            and   indid < 255)
   drop index Products.IndexProductSupplierId
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Products')
            and   type = 'U')
   drop table Products
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Suppliers')
            and   name  = 'IndexSupplierCountry'
            and   indid > 0
            and   indid < 255)
   drop index Suppliers.IndexSupplierCountry
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Suppliers')
            and   name  = 'IndexSupplierName'
            and   indid > 0
            and   indid < 255)
   drop index Suppliers.IndexSupplierName
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Suppliers')
            and   type = 'U')
   drop table Suppliers
go

/*==============================================================*/
/* Table: Customers                                            */
/*==============================================================*/
create table Customers (
   Id                   int                  identity,
   FirstName            nvarchar(40)         not null,
   LastName             nvarchar(40)         not null,
   City                 nvarchar(40)         null,
   Country              nvarchar(40)         null,
   Phone                nvarchar(20)         null,
   constraint PK_CUSTOMER primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexCustomerName                                     */
/*==============================================================*/
create index IndexCustomerName on Customers (
LastName ASC,
FirstName ASC
)
go

/*==============================================================*/
/* Table: "Orders"                                               */
/*==============================================================*/
create table Orders (
   Id                   int                  identity,
   OrderDate            datetime             not null default getdate(),
   OrderNumber          nvarchar(10)         null,
   CustomerId           int                  not null,
   TotalAmount          decimal(12,2)        null default 0,
   constraint PK_ORDER primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexOrderCustomerId                                  */
/*==============================================================*/
create index IndexOrderCustomerId on Orders (
CustomerId ASC
)
go

/*==============================================================*/
/* Index: IndexOrderOrderDate                                   */
/*==============================================================*/
create index IndexOrderOrderDate on Orders (
OrderDate ASC
)
go

/*==============================================================*/
/* Table: OrderItems                                             */
/*==============================================================*/
create table OrderItems (
   Id                   int                  identity,
   OrderId              int                  not null,
   ProductId            int                  not null,
   UnitPrice            decimal(12,2)        not null default 0,
   Quantity             int                  not null default 1,
   constraint PK_ORDERITEM primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexOrderItemOrderId                                 */
/*==============================================================*/
create index IndexOrderItemOrderId on OrderItems (
OrderId ASC
)
go

/*==============================================================*/
/* Index: IndexOrderItemProductId                               */
/*==============================================================*/
create index IndexOrderItemProductId on OrderItems (
ProductId ASC
)
go

/*==============================================================*/
/* Table: Products                                               */
/*==============================================================*/
create table Products (
   Id                   int                  identity,
   ProductName          nvarchar(50)         not null,
   SupplierId           int                  not null,
   UnitPrice            decimal(12,2)        null default 0,
   Package              nvarchar(30)         null,
   IsDiscontinued       bit                  not null default 0,
   constraint PK_PRODUCT primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexProductSupplierId                                */
/*==============================================================*/
create index IndexProductSupplierId on Products (
SupplierId ASC
)
go

/*==============================================================*/
/* Index: IndexProductName                                      */
/*==============================================================*/
create index IndexProductName on Products (
ProductName ASC
)
go

/*==============================================================*/
/* Table: Suppliers                                              */
/*==============================================================*/
create table Suppliers (
   Id                   int                  identity,
   CompanyName          nvarchar(40)         not null,
   ContactName          nvarchar(50)         null,
   ContactTitle         nvarchar(40)         null,
   City                 nvarchar(40)         null,
   Country              nvarchar(40)         null,
   Phone                nvarchar(30)         null,
   Fax                  nvarchar(30)         null,
   constraint PK_SUPPLIER primary key (Id)
)
go

/*==============================================================*/
/* Index: IndexSupplierName                                     */
/*==============================================================*/
create index IndexSupplierName on Suppliers (
CompanyName ASC
)
go

/*==============================================================*/
/* Index: IndexSupplierCountry                                  */
/*==============================================================*/
create index IndexSupplierCountry on Suppliers (
Country ASC
)
go

alter table Orders
   add constraint FK_ORDER_REFERENCE_CUSTOMER foreign key (CustomerId)
      references Customers (Id)
go

alter table OrderItems
   add constraint FK_ORDERITE_REFERENCE_ORDER foreign key (OrderId)
      references "Orders" (Id)
go

alter table OrderItems
   add constraint FK_ORDERITE_REFERENCE_PRODUCT foreign key (ProductId)
      references Products (Id)
go

alter table Products
   add constraint FK_PRODUCT_REFERENCE_SUPPLIER foreign key (SupplierId)
      references Suppliers (Id)
go