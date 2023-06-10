///////////////////////////////////////////////////////////////////////////////////////////////
// Asset Manager.
// Copyright (C) 2023-2023 the original author or authors.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; version 2
// of the License only.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
///////////////////////////////////////////////////////////////////////////////////////////////
package org.nanoboot.assetmanager.persistence.impl.mock;

import java.util.ArrayList;
import java.util.List;
import org.nanoboot.assetmanager.entity.Asset;
import org.nanoboot.assetmanager.persistence.api.AssetRepo;
import org.nanoboot.powerframework.time.moment.LocalDate;
import org.nanoboot.powerframework.time.moment.LocalDateTime;

/**
 *
 * @author robertvokac
 */
public class AssetRepoImplMock implements AssetRepo {

    private final List<Asset> internalList = new ArrayList<>();

    private int nextNumber = 1;

    @Override
    public List<Asset> list(int pageNumber, int pageSize, Integer number) {
        if (internalList.isEmpty()) {
            for(int i = 0;i< 50;i++) {
            internalList.add(
                    new Asset(
                            nextNumber++,
                            "electronics",
                            "computers",
                            "laptops",
                            null,
                            
                            "HP Elite Book 840G",
                            "hpeb840g",
                            new LocalDate(2023,03,03),
                            12300l,
                            "Kč",
                            
                            null,
                            null,
                            new LocalDateTime(2023,03,03,03,03,03,03)));
            }
        }
        List<Asset> finalList = new ArrayList<>();
        
        int numberEnd = pageSize * pageNumber;
        int numberStart = numberEnd - pageSize + 1;
        for (Asset a : internalList) {
            if(number != null) {
                if(a.getNumber().intValue() == number.intValue()) {
                    finalList.add(a);
                    break;
                } else {
                    continue;
                }
            }
            if (a.getNumber() < numberStart || a.getNumber() > numberEnd) {
                continue;
            }
            
            finalList.add(a);

        }
        return finalList;
    
    }

    @Override
    public int create(Asset asset) {
        asset.setNumber(nextNumber++);
        internalList.add(asset);
        return asset.getNumber();
    }

    @Override
    public Asset read(Integer number) {
        for (Asset w : internalList) {
            if (w.getNumber().intValue() == number.intValue()) {
                return w;
            }
        }
        return null;
    }

    @Override
    public void update(Asset asset) {
        Asset assetToBeDeleted = null;
        for (Asset v : internalList) {
            if (v.getNumber().intValue() == asset.getNumber().intValue()) {
                assetToBeDeleted = v;
                break;
            }
        }
        if (assetToBeDeleted == null) {
            //nothing to do
            return;
        }
        internalList.remove(assetToBeDeleted);
        internalList.add(asset);
        asset.setAddedOn(assetToBeDeleted.getAddedOn());

    }

}
