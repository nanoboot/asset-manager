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

package org.nanoboot.assetmanager.persistence.api;

import java.util.List;
import org.nanoboot.assetmanager.entity.Asset;

/**
 *
 * @author robertvokac
 */
public class AssetRepoWrapper implements AssetRepo {

    private AssetRepo internalAssetRepo;
    public AssetRepoWrapper(AssetRepo assetRepo) {
        this.internalAssetRepo = assetRepo;
    }
    @Override
    public List<Asset> list(int pageNumber, int pageSize, Integer number, String path1, String path2, String path3, String path4) {
        return internalAssetRepo.list(pageNumber, pageSize, number, path1, path2, path3, path4);
    }

    @Override
    public int create(Asset asset) {
        return internalAssetRepo.create(asset);
    }

    @Override
    public Asset read(Integer number) {
        return internalAssetRepo.read(number);
    }

    @Override
    public void update(Asset asset) {
        internalAssetRepo.update(asset);
    }
    
    
}
