// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Select course categories for LTI tool.
 *
 * @module     mod_lti/coursecategory
 * @package    mod_lti
 * @copyright  2020 Jackson D'souza <jackson.dsouza@catalyst-eu.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 * @since      3.9
 */

define(['jquery', 'core/tree'], function($) {

    /**
     * Add / Remove course category from the list. Update the lti_coursecategories hidden form field.
     */
    $("#modltitree .coursecategories").click(function(e) {
        e.stopPropagation();

        var listvalue = $('input[name="lti_coursecategories"]').val();
        var updatedlist = '';

        if ($(this).prop("checked")) {
            updatedlist = $(this).val();
            if (listvalue) {
                updatedlist = listvalue + "," + $(this).val();
            }
        } else {
            updatedlist = removeValue(listvalue, $(this).val(), ',');
        }
        $('input[name="lti_coursecategories"]').val(updatedlist);
    });

    /**
     * Show / hide child elements.
     */
    $("#modltitree .parent").click(function(e) {
        e.stopPropagation();
        $(this).find(">ul").toggle("slow");
        if ($(this).hasClass("myclose")) {
            $(this).removeClass("myclose");
        } else {
            $(this).addClass("myclose");
        }
    });

    /**
     * Remove list element from a given list.
     *
     * @method removeValue
     * @private
     * @param {string} list List.
     * @param {string} value Value that needs to be removed from the list.
     * @param {separator} separator List value seperator.
     * @return {string} Updated list.
     */
    var removeValue = function(list, value, separator) {
        separator = separator || ",";
        var values = list.split(separator);
        for (let i = 0; i < values.length; i++) {
            if (values[i] == value) {
                values.splice(i, 1);
                return values.join(separator);
            }
        }
        return list;
    };

    return /** @alias module:mod_lti/coursecategory */ {

        /**
         * Initialise this module.
         * Loop through checkbox form elements starting with #cat-{N} and set it to checked
         * if {N} is found in the Selected category(s) list. Show / Hide the parent UL element.
         *
         * @param {string} selectedcategories Selected category(s).
         */
        init: function(selectedcategories) {
            var separator = ",";
            var values = selectedcategories.split(separator);
            $('#modltitree .parent').find('>ul').hide();

            for (let i = 0; i < values.length; i++) {
                let $myvar = $("#cat-" + values[i]);
                if ($myvar.length !== 0) {
                    $myvar.prop('checked', true);
                }
                $myvar.parents('ul').each(function() {
                    $(this).show();
                });
                $myvar.parents('li').each(function() {
                    if (this != $myvar.parent()[0]) {
                        $(this).removeClass("myclose");
                    }
                });
            }
        }
    };
});