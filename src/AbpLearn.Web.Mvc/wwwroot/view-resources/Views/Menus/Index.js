(function ($) {
    var _menuService = abp.services.app.menus,
        l = abp.localization.getSource('A_b_p'),
        _$modal = $('#MenuCreateModal'),
        _$form = _$modal.find('form'),
        _$table = $('#MenusTable');

    var _$menusTable = _$table.DataTable({
        paging: true,
        serverSide: true,
        ajax: function (data, callback, settings) {
            var filter = $('#MenusSearchForm').serializeFormToObject(true);
            filter.maxResultCount = data.length;
            filter.skipCount = data.start;

            abp.ui.setBusy(_$table);
            _menuService.getAll(filter).done(function (result) {
                callback({
                    recordsTotal: result.totalCount,
                    recordsFiltered: result.totalCount,
                    data: result.items
                });
            }).always(function () {
                abp.ui.clearBusy(_$table);
            });
        },
        buttons: [
            {
                name: 'refresh',
                text: '<i class="fas fa-redo-alt"></i>',
                action: () => _$menusTable.draw(false)
            }
        ],
        responsive: {
            details: {
                type: 'column'
            }
        },
        columnDefs: [
            {
                targets: 0,
                className: 'control',
                defaultContent: '',
            },
            {
                targets: 1,
                data: 'id',
                sortable: false
            },
            {
                targets: 2,
                data: 'pageName',
                sortable: false
            },
            {
                targets: 3,
                data: 'menuName',
                sortable: false
            },
            {
                targets: 4,
                data: 'url',
                sortable: false
            },
            {
                targets: 5,
                data: 'icon',
                sortable: false
            },
            {
                targets: 6,
                data: 'parentId',
                sortable: false
            },
            {
                targets: 7,
                data: 'orders',
                sortable: false
            },
            {
                targets: 8,
                data: 'isActive',
                sortable: false,
                render: data => `<input type="checkbox" disabled ${data ? 'checked' : ''}>`
            },
            {
                targets: 9,
                data: null,
                sortable: false,
                autoWidth: false,
                defaultContent: '',
                render: (data, type, row, meta) => {
                    return [
                        `   <button type="button" class="btn btn-sm bg-secondary edit-menu" data-menu-id="${row.id}" data-toggle="modal" data-target="#MenuEditModal">`,
                        `       <i class="fas fa-pencil-alt"></i> ${l('Edit')}`,
                        '   </button>',
                        `   <button type="button" class="btn btn-sm bg-secondary btn-menu" data-menu-id="${row.id}" data-toggle="modal" data-target="#MenuBtnModal">`,
                        `       <i class="fas fa-pencil-alt"></i> ${l('Btn')}`,
                        '   </button>',
                        `   <button type="button" class="btn btn-sm bg-danger edit-user delete-menu" data-menu-id="${row.id}" data-tenancy-name="${row.name}">`,
                        `       <i class="fas fa-trash"></i> ${l('Delete')}`,
                        '   </button>'
                    ].join('');
                }
            }
        ]
    });

    _$form.find('.save-button').click(function (e) {
        e.preventDefault();

        if (!_$form.valid()) {
            return;
        }

        var systemMenu = _$form.serializeFormToObject();

        abp.ui.setBusy(_$modal);

        _menuService
            .create(systemMenu)
            .done(function () {
                _$modal.modal('hide');
                _$form[0].reset();
                abp.notify.info(l('SavedSuccessfully'));
                _$menusTable.ajax.reload();
            })
            .always(function () {
                abp.ui.clearBusy(_$modal);
            });
    });

    $(document).on('click', '.delete-menu', function () {
        var menuId = $(this).attr('data-menu-id');
        var tenancyName = $(this).attr('data-tenancy-name');

        deleteMenu(menuId, tenancyName);
    });

    $(document).on('click', '.edit-menu', function (e) {
        var menuId = $(this).attr('data-menu-id');

        abp.ajax({
            url: abp.appPath + 'Menus/EditModal?menuId=' + menuId,
            type: 'POST',
            dataType: 'html',
            success: function (content) {
                $('#MenuEditModal div.modal-content').html(content);
            },
            error: function (e) { }
        });
    });

    $(document).on('click', '.menu-menu', function (e) {
        var menuId = $(this).attr('data-menu-id');

        abp.ajax({
            url: abp.appPath + 'Menus/MenuBtnModal?menuId=' + menuId,
            type: 'POST',
            dataType: 'html',
            success: function (content) {
                $('#MenuBtnModal div.modal-content').html(content);
            },
            error: function (e) { }
        });
    });

    abp.event.on('menu.edited', (data) => {
        _$menusTable.ajax.reload();
    });

    function deleteMenu(menuId, tenancyName) {
        abp.message.confirm(
            abp.utils.formatString(
                l('AreYouSureWantToDelete'),
                tenancyName
            ),
            null,
            (isConfirmed) => {
                if (isConfirmed) {
                    _menuService
                        .delete({
                            id: menuId
                        })
                        .done(() => {
                            abp.notify.info(l('SuccessfullyDeleted'));
                            _$menusTable.ajax.reload();
                        });
                }
            }
        );
    }

    _$modal.on('shown.bs.modal', () => {
        _$modal.find('input:not([type=hidden]):first').focus();
    }).on('hidden.bs.modal', () => {
        _$form.clearForm();
    });

    $('.btn-search').on('click', (e) => {
        _$menusTable.ajax.reload();
    });

    $('.btn-clear').on('click', (e) => {
        $('input[name=Keyword]').val('');
        $('input[name=IsActive][value=""]').prop('checked', true);
        _$menusTable.ajax.reload();
    });

    $('.txt-search').on('keypress', (e) => {
        if (e.which === 13) {
            _$menusTable.ajax.reload();
            return false;
        }
    });

    $("#ChangeTenancyName").change(function (e) {
        location.href = "/Menus/Index/" + this.options[this.selectedIndex].value;
    });

    $(document).on('click', '#GivePermissions', function (e) {
        var tenantId = $(this).attr('data-tenant-id');

        abp.message.confirm(
            abp.utils.formatString(
                "是否赋予当前租户管理员账号所有权限？",
                "系统"
            ),
            null,
            (isConfirmed) => {
                if (isConfirmed) {
                    _menuService
                        .givePermissions({
                            id: tenantId
                        })
                        .done(() => {
                            abp.notify.info("操作成功！");
                            _$menusTable.ajax.reload();
                        });
                }
            }
        );
    });
})(jQuery);
