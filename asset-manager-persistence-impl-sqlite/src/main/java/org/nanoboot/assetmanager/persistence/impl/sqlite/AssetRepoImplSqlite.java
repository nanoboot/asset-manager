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

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;
import java.util.logging.Level;
import java.util.logging.Logger;
import lombok.Setter;
import org.nanoboot.assetmanager.entity.Asset;
import org.nanoboot.assetmanager.persistence.api.AssetRepo;
import org.nanoboot.powerframework.time.moment.LocalDate;
import org.nanoboot.powerframework.time.moment.LocalDateTime;

/**
 *
 * @author robertvokac
 */
public class AssetRepoImplSqlite implements AssetRepo {

    @Setter
    private SqliteConnectionFactory sqliteConnectionFactory;

    @Override
    public List<Asset> list(int pageNumber, int pageSize, Integer number, String path1, String path2, String path3, String path4) {
        Predicate<String> isNullOrBlank = (s) -> s == null || s.isBlank();
        var path1Set = isNullOrBlank.negate().test(path1);
        var path2Set = isNullOrBlank.negate().test(path2);
        var path3Set = isNullOrBlank.negate().test(path3);
        var path4Set = isNullOrBlank.negate().test(path4);
        final boolean aPathIsSet = path1Set || path2Set || path3Set || path4Set;
        if (aPathIsSet) {
            pageSize = 100;
        }

        int numberEnd = pageSize * pageNumber;
        int numberStart = numberEnd - pageSize + 1;

        List<Asset> result = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(AssetTable.TABLE_NAME)
                .append(" WHERE ");
        boolean pagingIsEnabled = number == null;

        if (pagingIsEnabled) {
            sb.append(AssetTable.NUMBER)
                    .append(" BETWEEN ? AND ? ");
        } else {
            sb.append("1=1");
        }

        if (number != null) {
            sb.append(" AND ").append(AssetTable.NUMBER)
                    .append("=?");
        }

        if (path1Set) {
            sb.append(" AND ").append(AssetTable.PATH1)
                    .append("=?");
        }
        if (path2Set) {
            sb.append(" AND ").append(AssetTable.PATH2)
                    .append("=?");
        }
        if (path3Set) {
            sb.append(" AND ").append(AssetTable.PATH3)
                    .append("=?");
        }
        if (path4Set) {
            sb.append(" AND ").append(AssetTable.PATH4)
                    .append("=?");
        }

        if (aPathIsSet) {
            sb.append("ORDER BY ")
                    .append(AssetTable.PATH1).append(", ")
                    .append(AssetTable.PATH2).append(", ")
                    .append(AssetTable.PATH3).append(", ")
                    .append(AssetTable.PATH4);
        }
        String sql = sb.toString();
        System.err.println(sql);
        int i = 0;
        ResultSet rs = null;
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            if (pagingIsEnabled) {
                stmt.setInt(++i, numberStart);
                stmt.setInt(++i, numberEnd);
            }

            if (number != null) {
                stmt.setInt(++i, number);
            }
            if (path1Set) {
                stmt.setString(++i, path1);
            }
            if (path2Set) {
                stmt.setString(++i, path2);
            }
            if (path3Set) {
                stmt.setString(++i, path3);
            }
            if (path4Set) {
                stmt.setString(++i, path4);
            }

            System.err.println(stmt.toString());
            rs = stmt.executeQuery();

            while (rs.next()) {
                result.add(extractAssetFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(AssetRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return result;
    }

    private static Asset extractAssetFromResultSet(final ResultSet rs) throws SQLException {
        String sinceString = rs.getString(AssetTable.SINCE);
        return new Asset(
                rs.getInt(AssetTable.NUMBER),
                rs.getString(AssetTable.PATH1),
                rs.getString(AssetTable.PATH2),
                rs.getString(AssetTable.PATH3),
                rs.getString(AssetTable.PATH4),
                //
                rs.getString(AssetTable.NAME),
                rs.getString(AssetTable.ALIAS),
                sinceString == null ? null : new LocalDate(sinceString),
                rs.getString(AssetTable.PRICE_VALUE) == null ? null : rs.getLong(AssetTable.PRICE_VALUE),
                rs.getString(AssetTable.PRICE_CURRENCY),
                //

                rs.getString(AssetTable.NOTE),
                rs.getString(AssetTable.IN_GROUP),
                new LocalDateTime(rs.getString(AssetTable.ADDED_ON))
        );
    }

    @Override
    public int create(Asset asset) {
        StringBuilder sb = new StringBuilder();
        sb
                .append("INSERT INTO ")
                .append(AssetTable.TABLE_NAME)
                .append("(")
                .append(AssetTable.PATH1).append(",")
                .append(AssetTable.PATH2).append(",")
                .append(AssetTable.PATH3).append(",")
                .append(AssetTable.PATH4).append(",")
                //
                .append(AssetTable.NAME).append(",")
                .append(AssetTable.ALIAS).append(",")
                .append(AssetTable.SINCE).append(",")
                .append(AssetTable.PRICE_VALUE).append(",")
                .append(AssetTable.PRICE_CURRENCY).append(",")
                //
                .append(AssetTable.NOTE).append(",")
                .append(AssetTable.IN_GROUP).append(",")
                .append(AssetTable.ADDED_ON);
        //

        sb.append(")")
                .append(" VALUES (?,?,?,?  ,?,?,?,?,? ,?,?,?)");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, asset.getPath1());
            stmt.setString(++i, asset.getPath2());
            stmt.setString(++i, asset.getPath3());
            stmt.setString(++i, asset.getPath4());
            //
            stmt.setString(++i, asset.getName());
            stmt.setString(++i, asset.getAlias());
            if (asset.getSince() == null) {
                stmt.setNull(++i, java.sql.Types.VARCHAR);
            } else {
                stmt.setString(++i, asset.getSince().toString());
            }
            if (asset.getPriceValue() == null) {
                stmt.setNull(++i, java.sql.Types.NUMERIC);
            } else {
                stmt.setLong(++i, asset.getPriceValue());
            }

            stmt.setString(++i, asset.getPriceCurrency());
            //
            stmt.setString(++i, asset.getNote());
            stmt.setString(++i, asset.getGroup());
            stmt.setString(++i, asset.getAddedOn().toString());
            //

            stmt.execute();
            System.out.println(stmt.toString());
            ResultSet rs = connection.createStatement().executeQuery("select last_insert_rowid() as last");
            while (rs.next()) {
                int numberOfNewAsset = rs.getInt("last");
                System.out.println("numberOfNewAsset=" + numberOfNewAsset);
                return numberOfNewAsset;
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.err.println("Error.");
        return 0;
    }

    @Override
    public Asset read(Integer number) {

        if (number == null) {
            throw new RuntimeException("number is null");
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(AssetTable.TABLE_NAME)
                .append(" WHERE ")
                .append(AssetTable.NUMBER)
                .append("=?");

        String sql = sb.toString();
        int i = 0;
        ResultSet rs = null;
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {

            stmt.setInt(++i, number);

            rs = stmt.executeQuery();

            while (rs.next()) {
                return extractAssetFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(AssetRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return null;
    }

    @Override
    public void update(Asset asset
    ) {
        StringBuilder sb = new StringBuilder();
        sb
                .append("UPDATE ")
                .append(AssetTable.TABLE_NAME)
                .append(" SET ")
                .append(AssetTable.PATH1).append("=?, ")
                .append(AssetTable.PATH2).append("=?, ")
                .append(AssetTable.PATH3).append("=?, ")
                .append(AssetTable.PATH4).append("=?, ")
                //
                .append(AssetTable.NAME).append("=?, ")
                .append(AssetTable.ALIAS).append("=?, ")
                .append(AssetTable.SINCE).append("=?, ")
                .append(AssetTable.PRICE_VALUE).append("=?, ")
                .append(AssetTable.PRICE_CURRENCY).append("=?, ")
                //

                .append(AssetTable.NOTE).append("=?, ")
                .append(AssetTable.IN_GROUP).append("=? ")
                .append(" WHERE ").append(AssetTable.NUMBER).append("=?");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, asset.getPath1());
            stmt.setString(++i, asset.getPath2());
            stmt.setString(++i, asset.getPath3());
            stmt.setString(++i, asset.getPath4());
            //
            stmt.setString(++i, asset.getName());
            stmt.setString(++i, asset.getAlias());
            if (asset.getSince() == null) {
                stmt.setNull(++i, java.sql.Types.VARCHAR);
            } else {
                stmt.setString(++i, asset.getSince().toString());
            }

            //
            //
            if (asset.getPriceValue() == null) {
                stmt.setNull(++i, java.sql.Types.NUMERIC);
            } else {
                stmt.setLong(++i, asset.getPriceValue());
            }

            stmt.setString(++i, asset.getPriceCurrency());
            //
            stmt.setString(++i, asset.getNote());
            stmt.setString(++i, asset.getGroup());
            stmt.setInt(++i, asset.getNumber());
            System.err.println(stmt.toString());
            int numberOfUpdatedRows = stmt.executeUpdate();
            System.out.println("numberOfUpdatedRows=" + numberOfUpdatedRows);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
