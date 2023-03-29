/****** Script for SelectTopNRows command from SSMS  ******/


SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Nashville Housing Data].[dbo].[Nashville Housing]

  -- Changing The Date Format 


SELECT SaleDate
FROM [Nashville Housing]

SELECT SaleDateCoverted, CONVERT(date,SaleDate)
FROM [Nashville Housing]

uPDATE [Nashville Housing]
SET SaleDate = CONVERT(date,SaleDate)

Alter Table [Nashville Housing]
Add SaleDateCoverted Date;

Update [Nashville Housing]
Set SaleDateCoverted = CONVERT(date,SaleDate)


--Lets Populate The Property Address Date To Replace Null Values


SELECT PropertyAddress
FROM [Nashville Housing]
WHERE PropertyAddress is null

SELECT *
FROM [Nashville Housing]
--where PropertyAddress is null
ORDER BY ParcelID

-- So Furthermore, We Say;


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Nashville Housing] a
JOIN [Nashville Housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Nashville Housing] a
Join [Nashville Housing] b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




-- Delimiting The PropertyAddress Column Into 3 Different Columns Namely ( Address City State )

select PropertyAddress
from  [Nashville Housing]


Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
from [Nashville Housing]


Alter Table [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


Alter Table [Nashville Housing]
Add PropertyCityAddress Nvarchar(255);

Update [Nashville Housing]
Set PropertyCityAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))





-- Delimiting The OwnerAddress Column Into 3 Different Columns Namely ( Address City State )

select OwnerAddress from [Nashville Housing]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From [Nashville Housing]




Alter Table [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) 




Alter Table [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) 


Alter Table [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing]
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


--Lets Change 'Y' And 'N' To 'Yes' And 'No' In The SoldAsVacant Column

select  Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [Nashville Housing]
Group by SoldAsVacant
order by 2

select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
from [Nashville Housing]


Update [Nashville Housing]
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End


--Removing Duplicates

With RowNumCTE AS(
select *,
ROW_NUMBER( ) Over (
Partition By ParcelID,
             PropertyAddress,
			 SalePrice,
			 Saledate,
			 LegalReference
			 Order By
			     UniqueID
				 ) row_num
from [Nashville Housing]
--Order by ParcelID
)
Delete
from RowNumCTE
where row_num > 1
--Order by PropertyAddress
 

 
 --Deleting Unused Columns


select *
from [Nashville Housing]

ALTER TABLE [Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Nashville Housing]
DROP COLUMN SaleDate