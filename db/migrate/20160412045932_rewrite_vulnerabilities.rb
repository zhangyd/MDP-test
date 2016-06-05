class RewriteVulnerabilities < ActiveRecord::Migration
  def change
  	drop_table :vulnerabilities
    create_table :vulnerabilities do |t|
	    t.string :cve_name
	    t.decimal :cvss_score
	    t.string :cav
	    t.string :cac
	    t.string :ca
	    t.string :cci
	    t.string :cai
	    t.string :cii
	    t.string :severity
	    t.string :dependency_id
	    t.text :description
      t.timestamps
    end
  end
end