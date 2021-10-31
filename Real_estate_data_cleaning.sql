

--- Data Cleaning in SQL Queries

Select * 
From SqlDatCleaning.dbo.Sheet1$
order by 1


--- Standardize the date format

Select SaleDate, CONVERT(Date, SaleDate)
From SqlDatCleaning.dbo.Sheet1$
order by 1






-- Populate Property Address Data


Select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From SqlDatCleaning.dbo.Sheet1$ a
Join SqlDatCleaning.dbo.Sheet1$ b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] < > B.[UniqueID ]
WHERE a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From SqlDatCleaning.dbo.Sheet1$ a
Join SqlDatCleaning.dbo.Sheet1$ b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] < > B.[UniqueID ]
WHERE a.PropertyAddress is null








-- Replace Y and N with Yes and No--


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From SqlDatCleaning.dbo.Sheet1$
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		END
From SqlDatCleaning.dbo.Sheet1$

UPDATE Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		END

From SqlDatCleaning.dbo.Sheet1$



-- Removing Duplicates--



WITH RowNumCTE AS(
Select *,
 ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
    ORDER by UniqueID )
row_num
From SqlDatCleaning.dbo.Sheet1$
)

DELETE
From RowNumCTE
where row_num  > 1






-- Remove unused columns--


Select *
From SqlDatCleaning.dbo.Sheet1$
ALTER TABLE SqlDatCleaning.dbo.Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress