INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('acids_and_bases_concept', 1, 0, 0, 'concentration', 1, NULL, '[\mathrm{H}^{+}]')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('angular_momentum_concept', 1, 1, 0, 'angular_momentum', -1, NULL)
  ('angular_momentum_concept', 1, 0, 0, 'moment_of_inertia', 1, NULL)
  ('angular_momentum_concept', 1, 0, 1, 'angular_velocity', 1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('archimedes_principle', 1, 1, 0, 'force', -1, NULL, 'F_b')
  ('archimedes_principle', 1, 0, 0, 'density', 1, NULL, NULL)
  ('archimedes_principle', 1, 0, 1, 'gravitational_constant', 1, NULL, NULL)
  ('archimedes_principle', 1, 0, 2, 'volume', 1, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('area_concept', 1, 1, 0, 'area', -1, NULL, NULL)
  ('area_concept', 1, 0, 0, 'length', 2, '{"en-us": "side"}', 's')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('atomic_physics_concept', 1, 1, 0, 'energy', -1, NULL, '\Delta{}', 'E')
  ('atomic_physics_concept', 1, 0, 0, 'frequency', 1, NULL, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('atomic_structure_concept', 1, 0, 0, 'charge', 0, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('capacitance_concept', 1, 1, 0, 'capacitance', -1, NULL)
  ('capacitance_concept', 1, 0, 0, 'charge', 1, NULL)
  ('capacitance_concept', 1, 0, 1, 'electric_potential', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('centripetal_acceleration', 1, 1, 0, 'acceleration', -1, '{"en-us": "c"}', NULL)
  ('centripetal_acceleration', 1, 0, 0, 'velocity', 2, NULL, NULL)
  ('centripetal_acceleration', 1, 0, 1, 'length', -1, NULL, 'r')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('chemical_bonding_concept', 1, 0, 0, 'charge', 0, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('chemical_equilibrium_concept', 1, 0, 0, 'concentration', 1, '{"en-us": "product"}', '[\mathrm{C}]')
  ('chemical_equilibrium_concept', 1, 0, 1, 'concentration', -1, '{"en-us": "reactant"}', '[\mathrm{A}]')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('chemical_kinetics_concept', 1, 0, 0, 'concentration', 1, NULL, '[\mathrm{A}]')
  ('chemical_kinetics_concept', 1, 0, 1, 'rate_constant', 1, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('chemical_reactions_concept', 1, 0, 0, 'mass', 0, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_special, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('circle_area', 1, 1, 0, NULL, 'area', -1, NULL, NULL)
  ('circle_area', 1, 0, 0, 'pi', NULL, NULL, NULL, NULL)
  ('circle_area', 1, 0, 1, NULL, 'length', 2, NULL, 'r')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_special, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('circle_circumference', 1, 1, 0, NULL, NULL, 'length', -1, NULL, 'C')
  ('circle_circumference', 1, 0, 0, 2, NULL, NULL, NULL, NULL, NULL)
  ('circle_circumference', 1, 0, 1, NULL, 'pi', NULL, NULL, NULL, NULL)
  ('circle_circumference', 1, 0, 2, NULL, NULL, 'length', 1, NULL, 'r')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('conservation_of_momentum', 1, 1, 0, 'mass', -1, '{"en-us": "1"}')
  ('conservation_of_momentum', 1, 1, 1, 'velocity', -1, '{"en-us": "initial"}')
  ('conservation_of_momentum', 2, 1, 0, 'mass', -1, '{"en-us": "2"}')
  ('conservation_of_momentum', 2, 1, 1, 'velocity', -1, '{"en-us": "initial"}')
  ('conservation_of_momentum', 3, 0, 0, 'mass', 1, '{"en-us": "1"}')
  ('conservation_of_momentum', 3, 0, 1, 'velocity', 1, '{"en-us": "final"}')
  ('conservation_of_momentum', 4, 0, 0, 'mass', 1, '{"en-us": "2"}')
  ('conservation_of_momentum', 4, 0, 1, 'velocity', 1, '{"en-us": "final"}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('continuity_equation_fluid', 1, 1, 0, 'area', -1, '{"en-us": "1"}')
  ('continuity_equation_fluid', 1, 1, 1, 'velocity', -1, '{"en-us": "1"}')
  ('continuity_equation_fluid', 2, 0, 0, 'area', 1, '{"en-us": "2"}')
  ('continuity_equation_fluid', 2, 0, 1, 'velocity', 1, '{"en-us": "2"}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('coordinate_geometry_concept', 1, 0, 0, 'length', 1, NULL, '\Delta{}', 'y')
  ('coordinate_geometry_concept', 1, 0, 1, 'length', -1, NULL, '\Delta{}', 'x')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('density_formula', 1, 1, 0, 'density', -1, NULL)
  ('density_formula', 1, 0, 0, 'mass', 1, NULL)
  ('density_formula', 1, 0, 1, 'volume', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('differential_equations_concept', 1, 0, 0, 'length', 0, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('diffraction_concept', 1, 1, 0, 'angle', 1, NULL, '\sin', NULL)
  ('diffraction_concept', 1, 0, 0, 'wavelength', 1, NULL, NULL, NULL)
  ('diffraction_concept', 1, 0, 1, 'length', -1, '{"en-us": "slit width"}', NULL, 'a')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_special, coeff_exponent, quantity_id, var_exponent, label) VALUES
  ('einstein_emc2', 1, 1, 0, NULL, NULL, 'energy', -1, NULL)
  ('einstein_emc2', 1, 0, 0, NULL, NULL, 'mass', 1, NULL)
  ('einstein_emc2', 1, 0, 1, 'e', 2, NULL, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('electric_fields_concept', 1, 1, 0, 'electric_field_strength', -1, NULL)
  ('electric_fields_concept', 1, 0, 0, 'force', 1, NULL)
  ('electric_fields_concept', 1, 0, 1, 'charge', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('electrochemistry_concept', 1, 1, 0, NULL, 'cell_potential', -1, NULL, 'E^\circ_\mathrm{cell}')
  ('electrochemistry_concept', 1, 0, 0, NULL, 'electric_potential', 1, NULL, 'E^\circ_\mathrm{cathode}')
  ('electrochemistry_concept', 2, 0, 0, -1, NULL, NULL, NULL, NULL)
  ('electrochemistry_concept', 2, 0, 1, NULL, 'electric_potential', 1, NULL, 'E^\circ_\mathrm{anode}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label, latex_prefix) VALUES
  ('electromagnetic_induction_concept', 1, 1, 0, -1, NULL, NULL, NULL, NULL)
  ('electromagnetic_induction_concept', 1, 0, 0, NULL, 'magnetic_flux', 1, NULL, NULL)
  ('electromagnetic_induction_concept', 1, 0, 1, NULL, 'time', -1, NULL, '\mathrm{d}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('electromagnetic_waves_concept', 1, 1, 0, 'velocity', -1, '{"en-us": "wave"}', 'c')
  ('electromagnetic_waves_concept', 1, 0, 0, 'frequency', 1, NULL, NULL)
  ('electromagnetic_waves_concept', 1, 0, 1, 'wavelength', 1, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('entropy_concept', 1, 1, 0, 'entropy', -1, NULL, '\Delta{}', 'S')
  ('entropy_concept', 1, 0, 0, 'heat', 1, NULL, NULL, 'Q')
  ('entropy_concept', 1, 0, 1, 'temperature', -1, NULL, NULL, 'T')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('escape_velocity_concept', 1, 1, 0, NULL, 'escape_velocity', -1, NULL, NULL)
  ('escape_velocity_concept', 1, 0, 0, 2, NULL, NULL, NULL, NULL)
  ('escape_velocity_concept', 1, 0, 1, NULL, 'gravitational_constant', 1, NULL, NULL)
  ('escape_velocity_concept', 1, 0, 2, NULL, 'mass', 1, NULL, NULL)
  ('escape_velocity_concept', 1, 0, 3, NULL, 'length', -1, NULL, 'r')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('exponents_concept', 1, 0, 0, 'length', 0, NULL, 'x')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label, latex_prefix) VALUES
  ('first_law_thermodynamics', 1, 1, 0, NULL, 'internal_energy', -1, NULL, '\Delta{}')
  ('first_law_thermodynamics', 2, 0, 0, NULL, 'heat', 1, NULL, NULL)
  ('first_law_thermodynamics', 3, 0, 0, -1, NULL, NULL, NULL, NULL)
  ('first_law_thermodynamics', 3, 0, 1, NULL, 'work', 1, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label, latex_prefix) VALUES
  ('first_law_thermodynamics_adiabatic', 1, 1, 0, NULL, 'internal_energy', -1, NULL, '\Delta{}')
  ('first_law_thermodynamics_adiabatic', 2, 0, 0, -1, NULL, NULL, NULL, NULL)
  ('first_law_thermodynamics_adiabatic', 2, 0, 1, NULL, 'work', 1, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix) VALUES
  ('first_law_thermodynamics_isochoric', 1, 1, 0, 'internal_energy', -1, NULL, '\Delta{}')
  ('first_law_thermodynamics_isochoric', 2, 0, 0, 'heat', 1, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('friction_concept', 1, 1, 0, 'force', -1, NULL, 'F_\mathrm{f}')
  ('friction_concept', 1, 0, 0, 'force', 1, NULL, 'N')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('heat_concept', 1, 1, 0, 'heat', -1, NULL, NULL, NULL)
  ('heat_concept', 1, 0, 0, 'mass', 1, NULL, NULL, NULL)
  ('heat_concept', 1, 0, 1, 'specific_heat_capacity', 1, NULL, NULL, NULL)
  ('heat_concept', 1, 0, 2, 'temperature', 1, NULL, '\Delta{}', 'T')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('heat_conduction', 1, 1, 0, -1, 'power', -1, NULL, NULL, 'P')
  ('heat_conduction', 1, 0, 0, NULL, 'thermal_conductivity', 1, NULL, NULL, 'k')
  ('heat_conduction', 1, 0, 1, NULL, 'area', 1, NULL, NULL, NULL)
  ('heat_conduction', 1, 0, 2, NULL, 'temperature', 1, NULL, '\Delta{}', 'T')
  ('heat_conduction', 1, 0, 3, NULL, 'length', -1, NULL, '\Delta{}', 'x')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('heat_engines_concept', 1, 1, 0, 'heat_engine_efficiency', -1, NULL)
  ('heat_engines_concept', 1, 0, 0, 'work', 1, NULL)
  ('heat_engines_concept', 1, 0, 1, 'heat', -1, '{"en-us": "in"}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label) VALUES
  ('hookes_law', 1, 1, 0, NULL, 'force', -1, NULL)
  ('hookes_law', 1, 0, 0, -1, NULL, NULL, NULL)
  ('hookes_law', 1, 0, 1, NULL, 'spring_constant', 1, NULL)
  ('hookes_law', 1, 0, 2, NULL, 'length', 1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('ideal_gas_law', 1, 1, 0, 'pressure', -1, NULL)
  ('ideal_gas_law', 1, 1, 1, 'volume', -1, NULL)
  ('ideal_gas_law', 2, 0, 0, 'amount', 1, NULL)
  ('ideal_gas_law', 2, 0, 1, 'gas_constant', 1, NULL)
  ('ideal_gas_law', 2, 0, 2, 'temperature', 1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('impulse_concept', 1, 1, 0, 'impulse', -1, NULL)
  ('impulse_concept', 1, 0, 0, 'force', 1, NULL)
  ('impulse_concept', 1, 0, 1, 'time', 1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('interference_concept', 1, 1, 0, 'length', -1, '{"en-us": "slit separation"}', NULL, 'd')
  ('interference_concept', 1, 0, 0, 'angle', 1, NULL, '\sin', NULL)
  ('interference_concept', 1, 0, 1, 'wavelength', 1, NULL, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_special, coeff_exponent, quantity_id, var_exponent, label) VALUES
  ('keplers_third_law', 1, 1, 0, NULL, NULL, NULL, 'period', -2, NULL)
  ('keplers_third_law', 2, 0, 0, 4, NULL, 1, NULL, NULL, NULL)
  ('keplers_third_law', 2, 0, 1, NULL, 'pi', 2, NULL, NULL, NULL)
  ('keplers_third_law', 2, 0, 2, NULL, NULL, NULL, 'gravitational_constant', -1, NULL)
  ('keplers_third_law', 2, 0, 3, NULL, NULL, NULL, 'mass', -1, NULL)
  ('keplers_third_law', 2, 0, 4, NULL, NULL, NULL, 'length', 3, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_exponent, quantity_id, var_exponent, label) VALUES
  ('kinetic_energy', 1, 1, 0, NULL, NULL, 'energy', -1, '{"en-us": "k"}')
  ('kinetic_energy', 1, 0, 0, 2, -1, NULL, NULL, NULL)
  ('kinetic_energy', 1, 0, 1, NULL, NULL, 'mass', 1, NULL)
  ('kinetic_energy', 1, 0, 2, NULL, NULL, 'velocity', 2, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('laws_of_sines_and_cosines_concept', 1, 1, 0, 'length', -1, NULL, NULL, 'a')
  ('laws_of_sines_and_cosines_concept', 1, 0, 0, 'angle', -1, NULL, '\sin', 'A')
  ('laws_of_sines_and_cosines_concept', 1, 0, 1, 'length', 1, NULL, NULL, 'b')
  ('laws_of_sines_and_cosines_concept', 1, 0, 2, 'angle', -1, NULL, '\sin', 'B')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('lens_equation', 1, 1, 0, 'length', 1, NULL, 'f')
  ('lens_equation', 2, 0, 0, 'length', -1, NULL, 'u')
  ('lens_equation', 3, 0, 0, 'length', -1, NULL, 'v')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('limiting_reactants_concept', 1, 0, 0, 'amount', 0, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('limits_concept', 1, 0, 0, 'length', 0, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('mirrors_concept', 1, 1, 0, 'length', -1, '{"en-us": "focal"}', 'f')
  ('mirrors_concept', 1, 0, 0, 'length', -1, '{"en-us": "object"}', 'u')
  ('mirrors_concept', 1, 0, 1, 'length', -1, '{"en-us": "image"}', 'v')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('molarity_formula', 1, 1, 0, 'concentration', -1, NULL)
  ('molarity_formula', 1, 0, 0, 'amount', 1, NULL)
  ('molarity_formula', 1, 0, 1, 'volume', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('moles_from_mass', 1, 1, 0, 'amount', -1, NULL)
  ('moles_from_mass', 1, 0, 0, 'mass', 1, NULL)
  ('moles_from_mass', 1, 0, 1, 'molar_mass', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('moment_of_inertia_concept', 1, 1, 0, 'moment_of_inertia', -1, NULL, NULL)
  ('moment_of_inertia_concept', 1, 0, 0, 'mass', 1, NULL, NULL)
  ('moment_of_inertia_concept', 1, 0, 1, 'length', 2, NULL, 'r')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('momentum_formula', 1, 1, 0, 'momentum', -1, NULL)
  ('momentum_formula', 1, 0, 0, 'mass', 1, NULL)
  ('momentum_formula', 1, 0, 1, 'velocity', 1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('newton_second_law_of_motion', 1, 1, 0, 'force', -1, NULL)
  ('newton_second_law_of_motion', 1, 0, 0, 'mass', 1, NULL)
  ('newton_second_law_of_motion', 1, 0, 1, 'acceleration', 1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('newtons_law_of_gravitation', 1, 1, 0, 'force', -1, NULL)
  ('newtons_law_of_gravitation', 1, 0, 0, 'gravitational_constant', 1, NULL)
  ('newtons_law_of_gravitation', 1, 0, 1, 'mass', 1, '{"en-us": "1"}')
  ('newtons_law_of_gravitation', 1, 0, 2, 'mass', 1, '{"en-us": "2"}')
  ('newtons_law_of_gravitation', 1, 0, 3, 'length', -2, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('ohms_law', 1, 1, 0, 'electric_potential', -1, NULL)
  ('ohms_law', 1, 0, 0, 'current', 1, NULL)
  ('ohms_law', 1, 0, 1, 'resistance', 1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('parallel_resistance', 1, 1, 0, 'resistance', 1, NULL)
  ('parallel_resistance', 2, 0, 0, 'resistance', -1, '{"en-us": "1"}')
  ('parallel_resistance', 3, 0, 0, 'resistance', -1, '{"en-us": "2"}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_special, coeff_exponent, quantity_id, var_exponent, label) VALUES
  ('particle_physics_concept', 1, 1, 0, NULL, NULL, 'energy', -2, NULL)
  ('particle_physics_concept', 2, 0, 0, NULL, NULL, 'momentum', 2, NULL)
  ('particle_physics_concept', 3, 0, 0, NULL, NULL, 'mass', 2, NULL)
  ('particle_physics_concept', 3, 0, 1, 'e', 2, NULL, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label, latex_prefix) VALUES
  ('pascals_principle', 1, 1, 0, -1, 'pressure', 1, NULL, '\Delta{}')
  ('pascals_principle', 1, 0, 0, NULL, 'density', 1, NULL, NULL)
  ('pascals_principle', 1, 0, 1, NULL, 'gravitational_constant', 1, NULL, NULL)
  ('pascals_principle', 1, 0, 2, NULL, 'length', 1, NULL, '\Delta{}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('percent_yield_concept', 1, 0, 0, 'amount', 1, '{"en-us": "actual"}')
  ('percent_yield_concept', 1, 0, 1, 'amount', -1, '{"en-us": "theoretical"}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_special, quantity_id, var_exponent, label) VALUES
  ('period_pendulum', 1, 1, 0, NULL, NULL, 'period', -1, NULL)
  ('period_pendulum', 1, 0, 0, 2, NULL, NULL, NULL, NULL)
  ('period_pendulum', 1, 0, 1, NULL, 'pi', NULL, NULL, NULL)
  ('period_pendulum', 1, 0, 2, NULL, NULL, 'length', 0.5, NULL)
  ('period_pendulum', 1, 0, 3, NULL, NULL, 'gravitational_constant', -0.5, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('periodic_table_concept', 1, 0, 0, 'amount', 0, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_exponent, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('plane_geometry_concept', 1, 1, 0, NULL, NULL, 'area', -1, NULL, NULL)
  ('plane_geometry_concept', 1, 0, 0, 2, -1, NULL, NULL, NULL, NULL)
  ('plane_geometry_concept', 1, 0, 1, NULL, NULL, 'length', 1, '{"en-us": "base"}', 'b')
  ('plane_geometry_concept', 1, 0, 2, NULL, NULL, 'length', 1, '{"en-us": "height"}', 'h')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('polarization_concept', 1, 1, 0, 'angle', 1, '{"en-us": "Brewster"}', '\tan', '\theta_\mathrm{B}')
  ('polarization_concept', 1, 0, 0, 'refractive_index', 1, '{"en-us": "transmitted"}', NULL, 'n_2')
  ('polarization_concept', 1, 0, 1, 'refractive_index', -1, '{"en-us": "incident"}', NULL, 'n_1')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_exponent, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('polygons_concept', 1, 1, 0, NULL, NULL, 'area', -1, NULL, NULL)
  ('polygons_concept', 1, 0, 0, 2, -1, NULL, NULL, NULL, NULL)
  ('polygons_concept', 1, 0, 1, NULL, NULL, 'length', 1, '{"en-us": "side"}', 's')
  ('polygons_concept', 1, 0, 2, NULL, NULL, 'angle', 1, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('polynomials_concept', 2, 0, 0, 'length', 2, NULL, 'x')
  ('polynomials_concept', 3, 0, 0, 'length', 1, NULL, 'x')
  ('polynomials_concept', 4, 0, 0, 'length', 0, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('potential_energy_concept', 1, 1, 0, 'potential_energy', -1, NULL, NULL)
  ('potential_energy_concept', 1, 0, 0, 'mass', 1, NULL, NULL)
  ('potential_energy_concept', 1, 0, 1, 'acceleration', 1, NULL, 'g')
  ('potential_energy_concept', 1, 0, 2, 'length', 1, NULL, 'h')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('power_formula', 1, 1, 0, 'work', -1, NULL)
  ('power_formula', 1, 0, 0, 'work', 1, NULL)
  ('power_formula', 1, 0, 1, 'time', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('pressure_concept', 1, 1, 0, 'pressure', -1, NULL)
  ('pressure_concept', 1, 0, 0, 'force', 1, NULL)
  ('pressure_concept', 1, 0, 1, 'area', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('projectile_motion_concept', 1, 1, 0, 'length', -1, '{"en-us": "range"}')
  ('projectile_motion_concept', 1, 0, 0, 'velocity', 2, '{"en-us": "initial"}')
  ('projectile_motion_concept', 1, 0, 1, 'acceleration', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('pythagorean_theorem', 1, 1, 0, 'length', -2, NULL)
  ('pythagorean_theorem', 2, 0, 0, 'length', 2, NULL)
  ('pythagorean_theorem', 3, 0, 0, 'length', 2, '{"en-us": "hypotenuse"}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('reflection_concept', 1, 1, 0, 'angle', -1, NULL, '\theta_\mathrm{i}')
  ('reflection_concept', 1, 0, 0, 'angle', 1, NULL, '\theta_\mathrm{r}')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('reynolds_number_concept', 1, 1, 0, 'reynolds_number', -1, NULL)
  ('reynolds_number_concept', 1, 0, 0, 'density', 1, NULL)
  ('reynolds_number_concept', 1, 0, 1, 'velocity', 1, NULL)
  ('reynolds_number_concept', 1, 0, 2, 'length', 1, NULL)
  ('reynolds_number_concept', 1, 0, 3, 'dynamic_viscosity', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_exponent, quantity_id, var_exponent, label) VALUES
  ('rotational_energy_concept', 1, 1, 0, NULL, NULL, 'rotational_energy', -1, NULL)
  ('rotational_energy_concept', 1, 0, 0, 2, -1, NULL, NULL, NULL)
  ('rotational_energy_concept', 1, 0, 1, NULL, NULL, 'moment_of_inertia', 1, NULL)
  ('rotational_energy_concept', 1, 0, 2, NULL, NULL, 'angular_velocity', 2, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix) VALUES
  ('snells_law', 1, 1, 0, 'refractive_index', -1, '{"en-us": "1"}', NULL)
  ('snells_law', 1, 1, 1, 'angle', -1, '{"en-us": "i"}', '\sin')
  ('snells_law', 2, 0, 0, 'refractive_index', 1, '{"en-us": "2"}', NULL)
  ('snells_law', 2, 0, 1, 'angle', 1, '{"en-us": "r"}', '\sin')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('surface_tension_concept', 1, 1, 0, 'surface_tension', -1, NULL)
  ('surface_tension_concept', 1, 0, 0, 'force', 1, NULL)
  ('surface_tension_concept', 1, 0, 1, 'length', -1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, label, symbol_overwrite) VALUES
  ('suvat_v2', 1, 1, 0, NULL, 'velocity', -2, '{"en-us": "final"}', NULL)
  ('suvat_v2', 2, 0, 0, NULL, 'velocity', 2, '{"en-us": "initial"}', 'u')
  ('suvat_v2', 3, 0, 0, 2, NULL, NULL, NULL, NULL)
  ('suvat_v2', 3, 0, 1, NULL, 'acceleration', 1, NULL, NULL)
  ('suvat_v2', 3, 0, 2, NULL, 'length', 1, NULL, 'r')
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_special, quantity_id, var_exponent, label) VALUES
  ('van_der_waals', 1, 1, 0, NULL, NULL, 'amount', -1, NULL)
  ('van_der_waals', 1, 1, 1, NULL, NULL, 'gas_constant', -1, NULL)
  ('van_der_waals', 1, 1, 2, NULL, NULL, 'temperature', -1, NULL)
  ('van_der_waals', 2, 0, 0, NULL, NULL, 'pressure', 1, NULL)
  ('van_der_waals', 2, 0, 1, NULL, NULL, 'volume', 1, NULL)
  ('van_der_waals', 3, 0, 0, -1, NULL, NULL, NULL, NULL)
  ('van_der_waals', 3, 0, 1, NULL, NULL, 'pressure', 1, NULL)
  ('van_der_waals', 3, 0, 2, NULL, NULL, 'amount', 1, NULL)
  ('van_der_waals', 3, 0, 3, NULL, 'b', NULL, NULL, NULL)
  ('van_der_waals', 4, 0, 0, NULL, 'a', NULL, NULL, NULL)
  ('van_der_waals', 4, 0, 1, NULL, NULL, 'amount', 2, NULL)
  ('van_der_waals', 4, 0, 2, NULL, NULL, 'volume', -1, NULL)
  ('van_der_waals', 5, 0, 0, -1, NULL, NULL, NULL, NULL)
  ('van_der_waals', 5, 0, 1, NULL, 'a', NULL, NULL, NULL)
  ('van_der_waals', 5, 0, 2, NULL, NULL, 'amount', 3, NULL)
  ('van_der_waals', 5, 0, 3, NULL, 'b', NULL, NULL, NULL)
  ('van_der_waals', 5, 0, 4, NULL, NULL, 'volume', -2, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
  ('wave_equation', 1, 1, 0, 'velocity', -1, NULL)
  ('wave_equation', 1, 0, 0, 'frequency', 1, NULL)
  ('wave_equation', 1, 0, 1, 'wavelength', 1, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix, symbol_overwrite) VALUES
  ('wave_interference_concept', 1, 1, 0, 'path_difference', -1, NULL, '\Delta', 'x')
  ('wave_interference_concept', 1, 0, 0, 'wavelength', 1, NULL, NULL, NULL)
;
INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_suffix) VALUES
  ('work_formula', 1, 1, 0, 'work', -1, NULL, NULL)
  ('work_formula', 1, 0, 0, 'force', 1, NULL, NULL)
  ('work_formula', 1, 0, 1, 'length', 1, NULL, NULL)
  ('work_formula', 1, 0, 2, 'angle', 1, NULL, '{}')
;