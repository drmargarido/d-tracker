local notification_window = require "src.ui.windows.notification_window"

return {
    --[[
        Detects if the method has failed and if it has, report the error
        using the error notification popup
    ]]
    report_error = function(result, err)
        if err ~= nil then
            notification_window.display(err)
        end

        return result, err
    end
}
