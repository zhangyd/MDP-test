module RepositoriesHelper
	def class_for_severity(severity)
		color_map = {'Low' => 'info', 'Medium' => 'warning', 'High' => 'danger'}
		color_map[severity]
	end

	def selected_severity_level
		if params[:severity].present? and ["High","Medium","Low"].include?(params[:severity])
			return params[:severity]
		else
			return "Severity Level"
		end
	end
end
