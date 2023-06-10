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
package org.nanoboot.assetmanager.persistence.impl.sqlite;

/**
 *
 * @author robertvokac
 */
public class AssetTable {
    public static final String TABLE_NAME = "ASSET";
    
    public static final String NUMBER = "NUMBER";
    public static final String PATH1 = "PATH1";
    public static final String PATH2 = "PATH2";
    public static final String PATH3 = "PATH3";
    public static final String PATH4 = "PATH4";
    //
    public static final String NAME = "NAME";
    public static final String ALIAS = "ALIAS";
    public static final String SINCE = "SINCE";
    public static final String PRICE_VALUE = "PRICE_VALUE";
    public static final String PRICE_CURRENCY = "PRICE_CURRENCY";
    //
    public static final String NOTE = "NOTE";
    public static final String IN_GROUP = "IN_GROUP";
    public static final String ADDED_ON = "ADDED_ON";
    
    
    private AssetTable() {
        //Not meant to be instantiated.
    }
    
}
