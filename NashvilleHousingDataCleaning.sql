USE ABANA
GO
SELECT * FROM NashvilleHousing

--Cleaning Data in SQL Queries

Select * from NashvilleHousing
---------------------------------------------------------------------------------------------------------------------
--Q1. Standardize date format 

Select SaleDate, convert(Date, SaleDate)[ConvertedDate] 
from NashvilleHousing

Update NashvilleHousing
Set SaleDate = convert(Date, SaleDate)

Alter table NashvilleHousing
Add saledateConverted Date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)


select SaleDateConverted, CONVERT(Date, SaleDate)[Saledateconverted2] From NashvilleHousing
-------------------------------------------------------------------------------------------------------------------------------------
--Q2. Populate property address data

select *
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select D.ParcelID, D.PropertyAddress, E.ParcelID, E.PropertyAddress, isnull(D.PropertyAddress, E.PropertyAddress)
from NashvilleHousing D
Join NashvilleHousing E
on D.ParcelID = E.ParcelID
and D.[UniqueID ] <> E.[UniqueID ]
Where D.PropertyAddress is null

Update D
set PropertyAddress = isnull(D.PropertyAddress, E.PropertyAddress)
from NashvilleHousing D
Join NashvilleHousing E
on D.ParcelID = E.ParcelID
and D.[UniqueID ] <> E.[UniqueID ]
Where D.PropertyAddress is null

----------------------------------------------------------------------------------------------------------
--Q3. Breaking out address into individual colums(Address, city, state)

Select PropertyAddress 
from NashvilleHousing
--where PropertyAddress is null
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) As Address
,SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) As Address
From NashvilleHousing 

Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress)-1)


Alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress))

---------------------------------------------------------------------------------------------------------------------------------

Select OwnerAddress from NashvilleHousing

Select
PARSENAME(Replace(ownerAddress, ',', '.'), 3), 
PARSENAME(Replace(ownerAddress, ',', '.'), 2),
PARSENAME(Replace(ownerAddress, ',', '.'), 1)
From NashvilleHousing


Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(ownerAddress, ',', '.'), 3)


Alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(ownerAddress, ',', '.'), 2)


Alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(ownerAddress, ',', '.'), 1)

Select * from NashvilleHousing
--=======================================================================================================================================

--Q4. Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(soldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case	When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End
From NashvilleHousing 

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
						When SoldAsVacant = 'N' Then 'No'
						Else SoldAsVacant
						End
Select * from NashvilleHousing
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--Q5. Remove Duplicates

With RowNUmCTE AS(
Select *,
ROW_NUMBER() Over (
Partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by UniqueID)Row_num
From NashvilleHousing
--Order by ParcelID
)
Select * From RowNUmCTE
where row_num > 1
Order by PropertyAddress
Go

With RowNUmCTE AS(
Select *,
ROW_NUMBER() Over (
Partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by UniqueID)Row_num
From NashvilleHousing
--Order by ParcelID
)
Delete From RowNUmCTE
where row_num > 1
---Order by PropertyAddress

--===========================================================================================================================

--Q6. Delete Unused Colums

Select * from NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table NashvilleHousing
Drop Column SaleDate
