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
package org.nanoboot.assetmanager.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.ToString;

/**
 *
 * @author <a href="mailto:robertvokac@nanoboot.org">Robert Vokac</a>
 * @since 0.0.0
 */
import org.nanoboot.powerframework.time.moment.LocalDate;
import org.nanoboot.powerframework.time.moment.LocalDateTime;

@Data
@AllArgsConstructor
@ToString
public class Asset {

    private Integer number;
    private String path1;
    private String path2;
    private String path3;
    private String path4;
    //
    private String name;
    private String alias;
    private LocalDate since;
    private Long priceValue;
    private String priceCurrency;
    //
    private String note;
    private String group;
    private LocalDateTime addedOn;

    public Asset() {
        
    }

    public String getPrettyPrice() {
        if (priceValue == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        sb.append(priceValue / 100);
        sb.append(".");
        String priceTimesHundredStr = priceValue.toString();
        if (priceValue == 0) {
            priceTimesHundredStr = priceTimesHundredStr + ".00";
        }
        sb.append(priceTimesHundredStr.substring(priceTimesHundredStr.length() - 2));
        if (priceCurrency != null && !priceCurrency.isBlank()) {
            sb.append(" ").append(priceCurrency);
        }

        return sb.toString();
    }

    public String getPriceAsString() {
        if (this.priceValue == null) {
            return null;
        }
        if(priceValue == 0) {
            return "0.00";
        }
        String priceString = priceValue.toString();
        return priceString.substring(0, priceString.length() - 2) + "." + priceString.substring(priceString.length() - 2);
    }

    public static Long convertPriceStringToPriceLong(String priceString) {
        priceString = priceString.replace(",",".");
        if (!priceString.contains(".")) {
            return Long.parseLong(priceString) * 100l;
        }
        if(priceString.charAt(priceString.length()-3) != '.') {
            throw new RuntimeException("Invalid format of price. The dot must be the third character from the end.");
        }
        Long long1 = Long.valueOf(priceString.substring(0, priceString.length()-3));
        Long long2 = Long.valueOf(priceString.substring(priceString.length()-2, priceString.length()));
        return long1 * 100 + long2;
    }

}
