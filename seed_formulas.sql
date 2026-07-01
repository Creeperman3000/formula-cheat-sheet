INSERT OR IGNORE INTO quantity (id, name, symbol, science, branch, subbranch, topic, difficulty, is_dim, default_unit, dim_M, dim_L, dim_T, dim_I, dim_Θ, dim_N, dim_J) VALUES
  ('absorbed_dose', '{"en-us": "Absorbed dose"}', 'D', 'physics', 'nuclear_physics', NULL, 'radiation', 4, 0, '[{"unit": "gray", "exponent": 1}]', 0.0,2.0,-2.0,0.0,0.0,0.0,0.0),
  ('mass', '{"en-us": "Mass"}', 'm', 'physics', 'classical_mechanics', 'dynamics', 'dynamics', 1, 1, '[{"unit": "kilogram", "exponent": 1}]', 1.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('length', '{"en-us": "Length"}', 'L', 'physics', 'classical_mechanics', 'kinematics', 'kinematics', 1, 1, '[{"unit": "metre", "exponent": 1}]', 0.0,1.0,0.0,0.0,0.0,0.0,0.0),
  ('temperature', '{"en-us": "Temperature"}', 'T', 'physics', 'thermodynamics', NULL, 'equations_of_state', 2, 1, '[{"unit": "kelvin", "exponent": 1}]', 0.0,0.0,0.0,0.0,1.0,0.0,0.0),
  ('absorbed_dose_rate', '{"en-us": "Absorbed dose rate"}', '\dot{D}', 'physics', 'nuclear_physics', NULL, 'radiation', 4, 0, '[{"unit": "gray_per_second", "exponent": 1}]', 0.0,2.0,-3.0,0.0,0.0,0.0,0.0),
  ('activity', '{"en-us": "Activity"}', 'A', 'physics', 'nuclear_physics', NULL, 'radioactivity', 3, 0, '[{"unit": "becquerel", "exponent": 1}]', 0.0,0.0,-1.0,0.0,0.0,0.0,0.0),
  ('angle', '{"en-us": "Angle"}', '\theta', 'mathematics', 'trigonometry', NULL, 'right_triangles', 1, 0, '[{"unit": "radian", "exponent": 1}]', 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('angular_acceleration', '{"en-us": "Angular acceleration"}', '\alpha', 'physics', 'classical_mechanics', 'rotational_mechanics', 'angular_acceleration', 3, 0, '[{"unit": "radian_per_second_sq", "exponent": 1}]', 0.0,0.0,-2.0,0.0,0.0,0.0,0.0),
  ('angular_momentum', '{"en-us": "Angular momentum"}', 'L', 'physics', 'classical_mechanics', 'rotational_mechanics', 'angular_momentum', 3, 0, '[{"unit": "kilogram", "exponent": 1}, {"unit": "square_metre", "exponent": 1}, {"unit": "second", "exponent": -1}]', 1.0,2.0,-1.0,0.0,0.0,0.0,0.0),
  ('angular_resolution', '{"en-us": "Angular resolution"}', '\theta_\mathrm{min}', 'physics', 'optics', 'physical_optics', 'diffraction', 4, 0, '[{"unit": "radian", "exponent": 1}]', 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('angular_velocity', '{"en-us": "Angular velocity"}', '\omega', 'physics', 'classical_mechanics', 'rotational_mechanics', 'angular_velocity', 3, 0, '[{"unit": "radian_per_second", "exponent": 1}]', 0.0,0.0,-1.0,0.0,0.0,0.0,0.0),
  ('area', '{"en-us": "Area"}', 'A', 'mathematics', 'geometry', NULL, 'circles', 1, 0, '[{"unit":"square_metre","exponent":1}]', 0.0,2.0,0.0,0.0,0.0,0.0,0.0),
  ('capacitance', '{"en-us": "Capacitance"}', 'C', 'physics', 'electromagnetism', NULL, 'circuits', 3, 0, '[{"unit": "farad", "exponent": 1}]', -1.0,-2.0,4.0,2.0,0.0,0.0,0.0),
  ('catalytic_activity', '{"en-us": "Catalytic activity"}', 'k', 'chemistry', 'physical_chemistry', NULL, 'kinetics', 3, 0, '[{"unit": "katal", "exponent": 1}]', 0.0,0.0,-1.0,0.0,0.0,1.0,0.0),
  ('catalytic_activity_concentration', '{"en-us": "Catalytic activity concentration"}', 'k_\mathrm{v}', 'chemistry', 'physical_chemistry', NULL, 'kinetics', 4, 0, '[{"unit": "katal_per_cubic_metre", "exponent": 1}]', 0.0,-3.0,-1.0,0.0,0.0,1.0,0.0),
  ('cell_potential', '{"en-us": "Cell potential"}', 'E_\mathrm{cell}', 'chemistry', 'physical_chemistry', NULL, 'electrochemistry', 4, 0, '[{"unit": "volt", "exponent": 1}]', 1.0,2.0,-3.0,-1.0,0.0,0.0,0.0),
  ('charge', '{"en-us": "Electric charge"}', 'Q', 'physics', 'electromagnetism', NULL, 'electrostatics', 2, 0, '[{"unit": "coulomb", "exponent": 1}]', 0.0,0.0,1.0,1.0,0.0,0.0,0.0),
  ('charge_density', '{"en-us": "Electric charge density"}', '\rho', 'physics', 'electromagnetism', NULL, 'electrostatics', 3, 0, '[{"unit": "coulomb_per_cubic_metre", "exponent": 1}]', 0.0,-3.0,1.0,1.0,0.0,0.0,0.0),
  ('concentration', '{"en-us": "Concentration"}', 'c', 'chemistry', 'physical_chemistry', NULL, 'solutions', 2, 0, '[{"unit": "mole", "exponent": 1}, {"unit": "cubic_metre", "exponent": -1}]', 0.0,-3.0,0.0,0.0,0.0,1.0,0.0),
  ('conductance', '{"en-us": "Electrical conductance"}', 'G', 'physics', 'electromagnetism', NULL, 'circuits', 3, 0, '[{"unit": "siemens", "exponent": 1}]', -1.0,-2.0,3.0,2.0,0.0,0.0,0.0),
  ('amount', '{"en-us": "Amount of substance"}', 'n', 'physics', 'thermodynamics', NULL, 'equations_of_state', 3, 1, '[{"unit": "mole", "exponent": 1}]', 0.0,0.0,0.0,0.0,0.0,1.0,0.0),
  ('current', '{"en-us": "Electric current"}', 'I', 'physics', 'electromagnetism', NULL, 'current_electricity', 2, 1, '[{"unit": "ampere", "exponent": 1}]', 0.0,0.0,0.0,1.0,0.0,0.0,0.0),
  ('current_density', '{"en-us": "Current density"}', 'j', 'physics', 'electromagnetism', NULL, 'circuits', 3, 0, '[{"unit": "ampere", "exponent": 1}, {"unit": "square_metre", "exponent": -1}]', 0.0,-2.0,0.0,1.0,0.0,0.0,0.0),
  ('degree_of_polarization', '{"en-us": "Degree of polarization"}', 'P', 'physics', 'optics', 'physical_optics', 'polarization', 4, 0, NULL, 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('density', '{"en-us": "Density"}', '\rho', 'physics', 'fluid_mechanics', 'fluid_statics', 'buoyancy', 2, 0, '[{"unit": "kilogram", "exponent": 1}, {"unit": "cubic_metre", "exponent": -1}]', 1.0,-3.0,0.0,0.0,0.0,0.0,0.0),
  ('dose_equivalent', '{"en-us": "Dose equivalent"}', 'H', 'physics', 'nuclear_physics', NULL, 'radiation', 4, 0, '[{"unit": "sievert", "exponent": 1}]', 0.0,2.0,-2.0,0.0,0.0,0.0,0.0),
  ('dynamic_viscosity', '{"en-us": "Dynamic viscosity"}', '\eta', 'physics', 'fluid_mechanics', NULL, 'viscosity', 3, 0, '[{"unit": "pascal_second", "exponent": 1}]', 1.0,-1.0,-1.0,0.0,0.0,0.0,0.0),
  ('electric_current', '{"en-us": "Electric current"}', 'I', 'physics', 'electromagnetism', NULL, 'circuits', 2, 0, '[{"unit": "ampere", "exponent": 1}]', 0.0,0.0,0.0,1.0,0.0,0.0,0.0),
  ('electric_field_strength', '{"en-us": "Electric field strength"}', 'E', 'physics', 'electromagnetism', NULL, 'electrostatics', 3, 0, '[{"unit": "volt_per_metre", "exponent": 1}]', 1.0,1.0,-3.0,-1.0,0.0,0.0,0.0),
  ('electric_potential', '{"en-us": "Electric potential"}', 'V', 'physics', 'electromagnetism', NULL, 'electric_potential', 3, 0, '[{"unit": "volt", "exponent": 1}]', 1.0,2.0,-3.0,-1.0,0.0,0.0,0.0),
  ('electromagnetic_induction', '{"en-us": "Electromagnetic induction"}', '\mathcal{E}', 'physics', 'electromagnetism', NULL, 'electromagnetic_induction', 4, 0, '[{"unit": "volt", "exponent": 1}]', 1.0,2.0,-3.0,-1.0,0.0,0.0,0.0),
  ('energy_density', '{"en-us": "Energy density"}', 'u', 'physics', 'thermodynamics', NULL, 'energy', 3, 0, '[{"unit": "joule_per_cubic_metre", "exponent": 1}]', 1.0,-1.0,-2.0,0.0,0.0,0.0,0.0),
  ('entropy', '{"en-us": "Entropy"}', 'S', 'physics', 'thermodynamics', NULL, 'second_law', 3, 0, '[{"unit": "joule_per_kelvin", "exponent": 1}]', 1.0,2.0,-2.0,0.0,-1.0,0.0,0.0),
  ('equilibrium_constant', '{"en-us": "Equilibrium constant"}', 'K_\mathrm{eq}', 'chemistry', 'physical_chemistry', NULL, 'chemical_equilibrium', 3, 0, NULL, 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('escape_velocity', '{"en-us": "Escape velocity"}', 'v_\mathrm{esc}', 'physics', 'classical_mechanics', 'gravitation', 'escape_velocity', 3, 0, '[{"unit": "metre_per_second", "exponent": 1}]', 0.0,1.0,-1.0,0.0,0.0,0.0,0.0),
  ('exposure', '{"en-us": "Exposure"}', 'X', 'physics', 'nuclear_physics', NULL, 'radiation', 4, 0, '[{"unit": "coulomb_per_kilogram", "exponent": 1}]', -1.0,0.0,1.0,1.0,0.0,0.0,0.0),
  ('frequency', '{"en-us": "Frequency"}', 'f', 'physics', 'classical_mechanics', 'oscillations_and_waves', 'harmonic_motion', 3, 0, '[{"unit": "hertz", "exponent": 1}]', 0.0,0.0,-1.0,0.0,0.0,0.0,0.0),
  ('heat_engine_efficiency', '{"en-us": "Heat engine efficiency"}', '\eta', 'physics', 'thermodynamics', NULL, 'heat_engines', 3, 0, NULL, 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('illuminance', '{"en-us": "Illuminance"}', 'E_\mathrm{v}', 'physics', 'optics', NULL, 'photometry', 3, 0, '[{"unit": "lux", "exponent": 1}]', 0.0,-2.0,0.0,0.0,0.0,0.0,1.0),
  ('impulse', '{"en-us": "Impulse"}', 'J', 'physics', 'classical_mechanics', 'momentum', 'impulse', 2, 0, '[{"unit": "kilogram", "exponent": 1}, {"unit": "metre", "exponent": 1}, {"unit": "second", "exponent": -1}]', 1.0,1.0,-1.0,0.0,0.0,0.0,0.0),
  ('inductance', '{"en-us": "Inductance"}', 'L', 'physics', 'electromagnetism', NULL, 'circuits', 3, 0, '[{"unit": "henry", "exponent": 1}]', 1.0,2.0,-2.0,-2.0,0.0,0.0,0.0),
  ('irradiance', '{"en-us": "Irradiance"}', 'E', 'physics', 'optics', NULL, 'radiometry', 3, 0, '[{"unit": "watt_per_square_metre", "exponent": 1}]', 1.0,0.0,-3.0,0.0,0.0,0.0,0.0),
  ('luminance', '{"en-us": "Luminance"}', 'L_\mathrm{v}', 'physics', 'optics', NULL, 'photometry', 3, 0, '[{"unit": "candela", "exponent": 1}, {"unit": "square_metre", "exponent": -1}]', 0.0,-2.0,0.0,0.0,0.0,0.0,1.0),
  ('luminous_flux', '{"en-us": "Luminous flux"}', '\Phi_\mathrm{v}', 'physics', 'optics', NULL, 'photometry', 3, 0, '[{"unit": "lumen", "exponent": 1}]', 0.0,0.0,0.0,0.0,0.0,0.0,1.0),
  ('luminous_intensity', '{"en-us": "Luminous intensity"}', 'I_\mathrm{v}', 'physics', 'optics', NULL, 'photometry', 3, 1, '[{"unit": "candela", "exponent": 1}]', 0.0,0.0,0.0,0.0,0.0,0.0,1.0),
  ('magnetic_field', '{"en-us": "Magnetic field"}', 'B', 'physics', 'electromagnetism', NULL, 'magnetism', 3, 0, '[{"unit": "tesla", "exponent": 1}]', 1.0,0.0,-2.0,-1.0,0.0,0.0,0.0),
  ('magnetic_field_strength', '{"en-us": "Magnetic field strength"}', 'H', 'physics', 'electromagnetism', NULL, 'magnetism', 3, 0, '[{"unit": "ampere", "exponent": 1}, {"unit": "metre", "exponent": -1}]', 0.0,-1.0,0.0,1.0,0.0,0.0,0.0),
  ('magnetic_flux', '{"en-us": "Magnetic flux"}', '\Phi', 'physics', 'electromagnetism', NULL, 'magnetism', 3, 0, '[{"unit": "weber", "exponent": 1}]', 1.0,2.0,-2.0,-1.0,0.0,0.0,0.0),
  ('magnetic_flux_density', '{"en-us": "Magnetic flux density"}', 'B', 'physics', 'electromagnetism', NULL, 'magnetism', 3, 0, '[{"unit": "tesla", "exponent": 1}]', 1.0,0.0,-2.0,-1.0,0.0,0.0,0.0),
  ('mass_concentration', '{"en-us": "Mass concentration"}', '\gamma', 'chemistry', 'physical_chemistry', NULL, 'solutions', 3, 0, '[{"unit": "kilogram", "exponent": 1}, {"unit": "cubic_metre", "exponent": -1}]', 1.0,-3.0,0.0,0.0,0.0,0.0,0.0),
  ('molar_energy', '{"en-us": "Molar energy"}', 'E_\mathrm{m}', 'chemistry', 'physical_chemistry', NULL, 'thermochemistry', 3, 0, '[{"unit": "joule_per_mole", "exponent": 1}]', 1.0,2.0,-2.0,0.0,0.0,-1.0,0.0),
  ('molar_entropy', '{"en-us": "Molar entropy"}', 'S_\mathrm{m}', 'chemistry', 'physical_chemistry', NULL, 'thermochemistry', 3, 0, '[{"unit": "joule_per_mole_kelvin", "exponent": 1}]', 1.0,2.0,-2.0,0.0,-1.0,-1.0,0.0),
  ('molar_mass', '{"en-us": "Molar mass"}', 'M', 'chemistry', 'stoichiometry', NULL, 'molar_mass', 2, 0, '[{"unit":"kilogram_per_mole","exponent":1}]', 1.0,0.0,0.0,0.0,0.0,-1.0,0.0),
  ('moment_of_inertia', '{"en-us": "Moment of inertia"}', 'I', 'physics', 'classical_mechanics', 'rotational_mechanics', 'moment_of_inertia', 3, 0, '[{"unit": "kilogram", "exponent": 1}, {"unit": "square_metre", "exponent": 1}]', 1.0,2.0,0.0,0.0,0.0,0.0,0.0),
  ('path_difference', '{"en-us": "Path difference"}', '\Delta x', 'physics', 'optics', 'physical_optics', 'interference', 3, 0, '[{"unit": "metre", "exponent": 1}]', 0.0,1.0,0.0,0.0,0.0,0.0,0.0),
  ('permeability', '{"en-us": "Permeability"}', '\mu', 'physics', 'electromagnetism', NULL, 'magnetism', 4, 0, '[{"unit": "henry_per_metre", "exponent": 1}]', 1.0,1.0,-2.0,-2.0,0.0,0.0,0.0),
  ('permittivity', '{"en-us": "Permittivity"}', '\varepsilon', 'physics', 'electromagnetism', NULL, 'electrostatics', 4, 0, '[{"unit": "farad_per_metre", "exponent": 1}]', -1.0,-3.0,4.0,2.0,0.0,0.0,0.0),

  ('power', '{"en-us": "Power"}', 'P', 'physics', 'classical_mechanics', NULL, 'energy', 2, 0, '[{"unit": "watt", "exponent": 1}]', 1.0,2.0,-3.0,0.0,0.0,0.0,0.0),
  ('radiance', '{"en-us": "Radiance"}', 'L_\mathrm{e}', 'physics', 'optics', NULL, 'radiometry', 4, 0, '[{"unit": "watt_per_square_metre_steradian", "exponent": 1}]', 1.0,0.0,-3.0,0.0,0.0,0.0,0.0),
  ('radiant_intensity', '{"en-us": "Radiant intensity"}', 'I_\mathrm{e}', 'physics', 'optics', NULL, 'radiometry', 4, 0, '[{"unit": "watt_per_steradian", "exponent": 1}]', 1.0,2.0,-3.0,0.0,0.0,0.0,0.0),
  ('rate_constant', '{"en-us": "Rate constant"}', 'k', 'chemistry', 'physical_chemistry', NULL, 'chemical_kinetics', 3, 0, '[{"unit": "second", "exponent": -1}]', 0.0,0.0,-1.0,0.0,0.0,0.0,0.0),
  ('reflectance', '{"en-us": "Reflectance"}', 'R', 'physics', 'optics', 'geometrical_optics', 'reflection', 2, 0, NULL, 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('refractive_index', '{"en-us": "Refractive index"}', 'n', 'physics', 'optics', 'geometrical_optics', 'refraction', 3, 0, NULL, 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('reynolds_number', '{"en-us": "Reynolds number"}', '\mathit{Re}', 'physics', 'fluid_mechanics', 'fluid_dynamics', 'reynolds_number', 3, 0, NULL, 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('solid_angle', '{"en-us": "Solid angle"}', '\Omega', 'physics', 'trigonometry', NULL, 'trigonometric_identities', 2, 0, '[{"unit": "steradian", "exponent": 1}]', 0.0,0.0,0.0,0.0,0.0,0.0,0.0),
  ('specific_energy', '{"en-us": "Specific energy"}', 'e', 'physics', 'thermodynamics', NULL, 'energy', 3, 0, '[{"unit": "joule_per_kilogram", "exponent": 1}]', 0.0,2.0,-2.0,0.0,0.0,0.0,0.0),
  ('specific_heat_capacity', '{"en-us": "Specific heat capacity"}', 'c', 'physics', 'thermodynamics', NULL, 'heat_transfer', 3, 0, '[{"unit": "joule_per_kilogram_kelvin", "exponent": 1}]', 0.0,2.0,-2.0,0.0,-1.0,0.0,0.0),
  ('specific_volume', '{"en-us": "Specific volume"}', 'v', 'physics', 'thermodynamics', NULL, 'continuum_mechanics', 3, 0, '[{"unit": "cubic_metre", "exponent": 1}, {"unit": "kilogram", "exponent": -1}]', -1.0,3.0,0.0,0.0,0.0,0.0,0.0),
  ('spring_constant', '{"en-us": "Spring constant"}', 'k', 'physics', 'classical_mechanics', 'dynamics', 'springs', 3, 0, '[{"unit": "newton", "exponent": 1}, {"unit": "metre", "exponent": -1}]', 1.0,0.0,-2.0,0.0,0.0,0.0,0.0),
  ('surface_charge_density', '{"en-us": "Surface charge density"}', '\sigma', 'physics', 'electromagnetism', NULL, 'electrostatics', 3, 0, '[{"unit": "coulomb_per_square_metre", "exponent": 1}]', 0.0,-2.0,1.0,1.0,0.0,0.0,0.0),
  ('surface_density', '{"en-us": "Surface density"}', '\rho_A', 'physics', 'thermodynamics', NULL, 'continuum_mechanics', 3, 0, '[{"unit": "kilogram", "exponent": 1}, {"unit": "square_metre", "exponent": -1}]', 1.0,-2.0,0.0,0.0,0.0,0.0,0.0),
  ('surface_tension', '{"en-us": "Surface tension"}', '\gamma', 'physics', 'fluid_mechanics', NULL, 'surface_phenomena', 3, 0, '[{"unit": "newton_per_metre", "exponent": 1}]', 1.0,0.0,-2.0,0.0,0.0,0.0,0.0),
  ('thermal_conductivity', '{"en-us": "Thermal conductivity"}', 'k', 'physics', 'thermodynamics', NULL, 'heat_transfer', 3, 0, '[{"unit": "watt_per_metre_kelvin", "exponent": 1}]', 1.0,1.0,-3.0,0.0,-1.0,0.0,0.0),
  ('time', '{"en-us": "Time"}', 't', 'physics', 'classical_mechanics', 'kinematics', 'constant_acceleration', 1, 1, '[{"unit": "second", "exponent": 1}]', 0.0,0.0,1.0,0.0,0.0,0.0,0.0),
  ('torque', '{"en-us": "Torque"}', '\tau', 'physics', 'classical_mechanics', 'rotational_mechanics', 'torque', 3, 0, '[{"unit": "newton_metre", "exponent": 1}]', 1.0,2.0,-2.0,0.0,0.0,0.0,0.0),
  ('wavelength', '{"en-us": "Wavelength"}', '\lambda', 'physics', 'classical_mechanics', 'oscillations_and_waves', 'mechanical_waves', 3, 0, '[{"unit": "metre", "exponent": 1}]', 0.0,1.0,0.0,0.0,0.0,0.0,0.0),
  ('wavenumber', '{"en-us": "Wavenumber"}', '\tilde{\nu}', 'physics', 'optics', NULL, 'waves', 3, 0, '[{"unit": "metre", "exponent": -1}]', 0.0,-1.0,0.0,0.0,0.0,0.0,0.0);

INSERT OR IGNORE INTO unit (id, name, symbol, quantity_id, default_unit, unit_system, factor, latex_factor, offset) VALUES
('tesla_magnetic_field', '{"en-us": "Tesla"}', '\mathrm{T}', 'magnetic_field', 1, 'SI', 1.0, NULL, 0.0),
('wavelength_metre', '{"en-us": "Metre"}', '\mathrm{m}', 'wavelength', 1, 'SI', 1.0, NULL, 0.0);

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('acids_and_bases', '{"en-us": "Acids And Bases"}', 'chemistry', 'physical_chemistry', NULL, 'acids_and_bases', 2, '{"en-us": "The pH equals the negative logarithm of the hydrogen ion concentration."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('angular_momentum', '{"en-us": "Angular Momentum"}', 'physics', 'classical_mechanics', 'rotational_mechanics', 'angular_momentum', 2, '{"en-us": "Angular momentum equals the product of moment of inertia and angular velocity."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('archimedes_principle', '{"en-us": "Archimedes'' principle"}', 'physics', 'fluid_mechanics', 'fluid_statics', 'buoyancy', 3, '{"en-us": "The buoyant force on a submerged object equals the weight of the fluid displaced."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('area', '{"en-us": "Area"}', 'mathematics', 'geometry', NULL, 'area', 2, '{"en-us": "The area of a square equals the square of its side length."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('atomic_physics', '{"en-us": "Atomic Physics"}', 'physics', 'modern_physics', NULL, 'atomic_physics', 2, '{"en-us": "The energy of a photon equals Planck''s constant times its frequency."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('atomic_structure', '{"en-us": "Atomic Structure"}', 'chemistry', 'general_chemistry', NULL, 'atomic_structure', 2, '{"en-us": "Atoms consist of protons, neutrons, and electrons arranged in a nucleus and orbiting shells."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('bernoulli_equation', '{"en-us": "Bernoulli''s equation"}', 'physics', 'fluid_mechanics', 'fluid_dynamics', 'bernoulli_equation', 4, '{"en-us": "For an ideal fluid, the sum of pressure, kinetic energy per volume, and potential energy per volume is constant along a streamline."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('capacitance', '{"en-us": "Capacitance"}', 'physics', 'electromagnetism', NULL, 'capacitance', 2, '{"en-us": "Capacitance equals the charge stored per unit electric potential difference."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('centripetal_acceleration', '{"en-us": "Centripetal acceleration"}', 'physics', 'classical_mechanics', 'kinematics', 'circular_motion', 3, '{"en-us": "The centripetal acceleration of an object moving in a circle equals the square of its velocity divided by the radius."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('chemical_bonding', '{"en-us": "Chemical Bonding"}', 'chemistry', 'general_chemistry', NULL, 'chemical_bonding', 2, '{"en-us": "Atoms bond together by sharing or transferring electrons to achieve stable electron configurations."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('chemical_equilibrium', '{"en-us": "Chemical Equilibrium"}', 'chemistry', 'physical_chemistry', NULL, 'chemical_equilibrium', 2, '{"en-us": "The equilibrium constant equals the ratio of product concentrations to reactant concentrations."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('chemical_kinetics', '{"en-us": "Chemical Kinetics"}', 'chemistry', 'physical_chemistry', NULL, 'chemical_kinetics', 2, '{"en-us": "The rate of a chemical reaction equals the rate constant times the concentration of reactants."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('chemical_reactions', '{"en-us": "Chemical Reactions"}', 'chemistry', 'general_chemistry', NULL, 'chemical_reactions', 2, '{"en-us": "Chemical reactions involve the rearrangement of atoms to form new substances."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('circle_area', '{"en-us": "Area of a circle"}', 'mathematics', 'geometry', NULL, 'circles', 1, '{"en-us": "The area of a circle is pi times the radius squared."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('circle_circumference', '{"en-us": "Circumference of a circle"}', 'mathematics', 'geometry', NULL, 'circles', 1, '{"en-us": "The circumference of a circle is 2 pi times the radius."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('continuity_equation_fluid', '{"en-us": "Continuity equation for fluids"}', 'physics', 'fluid_mechanics', 'fluid_dynamics', 'continuity_equation', 3, '{"en-us": "For an incompressible fluid, the product of cross-sectional area and velocity is constant along a streamline."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('coordinate_geometry', '{"en-us": "Coordinate Geometry"}', 'mathematics', 'geometry', NULL, 'coordinate_geometry', 2, '{"en-us": "The slope of a line equals the change in y divided by the change in x."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('density_formula', '{"en-us": "Density"}', 'physics', 'fluid_mechanics', 'fluid_statics', 'buoyancy', 1, '{"en-us": "Density equals mass divided by volume."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('derivative_power', '{"en-us": "Power rule for derivatives"}', 'mathematics', 'calculus', NULL, 'derivatives', 2, '{"en-us": "The derivative of x to the power n is n times x to the power n minus one."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('differential_equations', '{"en-us": "Differential Equations"}', 'mathematics', 'calculus', NULL, 'differential_equations', 2, '{"en-us": "A differential equation relates a function to its derivatives, describing rates of change."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('diffraction', '{"en-us": "Diffraction"}', 'physics', 'optics', 'physical_optics', 'diffraction', 2, '{"en-us": "For single-slit diffraction minima, the sine of the angle equals the wavelength divided by the slit width."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('einstein_emc2', '{"en-us": "Mass-energy equivalence"}', 'physics', 'modern_physics', NULL, 'relativity', 4, '{"en-us": "Energy equals mass times the speed of light squared."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('electric_fields', '{"en-us": "Electric Fields"}', 'physics', 'electromagnetism', NULL, 'electric_fields', 2, '{"en-us": "Electric field strength equals the force per unit charge."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('electrochemistry', '{"en-us": "Electrochemistry"}', 'chemistry', 'physical_chemistry', NULL, 'electrochemistry', 2, '{"en-us": "The standard cell potential equals the difference between the cathode and anode standard potentials."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('electromagnetic_induction', '{"en-us": "Electromagnetic Induction"}', 'physics', 'electromagnetism', NULL, 'electromagnetic_induction', 2, '{"en-us": "The induced electromotive force equals negative the rate of change of magnetic flux."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('electromagnetic_waves', '{"en-us": "Electromagnetic Waves"}', 'physics', 'electromagnetism', NULL, 'electromagnetic_waves', 2, '{"en-us": "The speed of an electromagnetic wave equals frequency times wavelength."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('entropy', '{"en-us": "Entropy"}', 'physics', 'thermodynamics', NULL, 'entropy', 2, '{"en-us": "The change in entropy equals heat transferred divided by temperature."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('escape_velocity', '{"en-us": "Escape Velocity"}', 'physics', 'classical_mechanics', 'gravitation', 'escape_velocity', 2, '{"en-us": "Escape velocity equals the square root of twice the gravitational constant times mass divided by radius."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('exponents', '{"en-us": "Exponents"}', 'mathematics', 'algebra', NULL, 'exponents', 2, '{"en-us": "Exponents indicate repeated multiplication of a base number by itself."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('friction', '{"en-us": "Friction"}', 'physics', 'classical_mechanics', 'dynamics', 'friction', 2, '{"en-us": "The force of friction equals the product of the coefficient of friction and the normal force."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('heat', '{"en-us": "Heat"}', 'physics', 'thermodynamics', NULL, 'heat', 2, '{"en-us": "The heat transferred equals mass times specific heat capacity times the change in temperature."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('heat_conduction', '{"en-us": "Heat conduction (Fourier''s law)"}', 'physics', 'thermodynamics', NULL, 'heat_transfer', 3, '{"en-us": "The rate of heat transfer through a material is proportional to its thermal conductivity, area, and temperature gradient."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('heat_engines', '{"en-us": "Heat Engines"}', 'physics', 'thermodynamics', NULL, 'heat_engines', 2, '{"en-us": "The efficiency of a heat engine equals work output divided by heat input."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('hookes_law', '{"en-us": "Hooke''s law"}', 'physics', 'classical_mechanics', 'dynamics', 'springs', 2, '{"en-us": "The force exerted by a spring is proportional to its displacement from equilibrium."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('impulse', '{"en-us": "Impulse"}', 'physics', 'classical_mechanics', 'momentum', 'impulse', 2, '{"en-us": "Impulse equals the product of force and the time interval over which it acts."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('integral_power', '{"en-us": "Power rule for integrals"}', 'mathematics', 'calculus', NULL, 'integrals', 2, '{"en-us": "The integral of x to the power n is x to the power n plus one divided by n plus one."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('interference', '{"en-us": "Interference"}', 'physics', 'optics', 'physical_optics', 'interference', 2, '{"en-us": "For double-slit interference, the slit separation times the sine of the angle equals an integer multiple of the wavelength."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('laws_of_sines_and_cosines', '{"en-us": "Laws Of Sines And Cosines"}', 'mathematics', 'trigonometry', NULL, 'laws_of_sines_and_cosines', 2, '{"en-us": "The ratio of a side length to the sine of its opposite angle is constant for all sides of a triangle."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('lens_equation', '{"en-us": "Thin lens equation"}', 'physics', 'optics', 'geometrical_optics', 'lenses', 3, '{"en-us": "The inverse of the focal length equals the sum of the inverse of the object distance and the inverse of the image distance."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('limiting_reactants', '{"en-us": "Limiting Reactants"}', 'chemistry', 'stoichiometry', NULL, 'limiting_reactants', 2, '{"en-us": "The limiting reactant determines the maximum amount of product that can be formed in a reaction."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('limits', '{"en-us": "Limits"}', 'mathematics', 'calculus', NULL, 'limits', 2, '{"en-us": "A limit describes the value a function approaches as the input approaches a particular value."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('logarithm_product', '{"en-us": "Logarithm of a product"}', 'mathematics', 'algebra', NULL, 'logarithms', 2, '{"en-us": "The logarithm of a product equals the sum of the logarithms."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('mirrors', '{"en-us": "Mirrors"}', 'physics', 'optics', 'geometrical_optics', 'mirrors', 2, '{"en-us": "The inverse of the focal length equals the sum of the inverses of the object and image distances."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('molarity_formula', '{"en-us": "Molarity"}', 'chemistry', 'stoichiometry', NULL, 'solution_stoichiometry', 2, '{"en-us": "Molarity equals the number of moles of solute divided by the volume of solution in litres."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('moles_from_mass', '{"en-us": "Moles from mass"}', 'chemistry', 'stoichiometry', NULL, 'mole_concept', 2, '{"en-us": "The number of moles equals the mass divided by the molar mass."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('moment_of_inertia', '{"en-us": "Moment Of Inertia"}', 'physics', 'classical_mechanics', 'rotational_mechanics', 'moment_of_inertia', 2, '{"en-us": "The moment of inertia of a point mass equals its mass times the square of its distance from the axis."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('momentum_formula', '{"en-us": "Linear momentum"}', 'physics', 'classical_mechanics', 'momentum', 'linear_momentum', 1, '{"en-us": "The linear momentum of an object is its mass times its velocity."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('newtons_law_of_gravitation', '{"en-us": "Newton''s law of universal gravitation"}', 'physics', 'classical_mechanics', 'gravitation', 'newtonian_gravity', 3, '{"en-us": "Every particle attracts every other particle with a force proportional to the product of their masses and inversely proportional to the square of the distance."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('ohms_law', '{"en-us": "Ohm''s law"}', 'physics', 'electromagnetism', NULL, 'circuits', 2, '{"en-us": "The current through a conductor is directly proportional to the voltage across it."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('particle_physics', '{"en-us": "Particle Physics"}', 'physics', 'modern_physics', NULL, 'particle_physics', 2, '{"en-us": "The square of total relativistic energy equals the square of momentum times c squared plus the square of rest energy."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('pascals_principle', '{"en-us": "Pascal''s principle"}', 'physics', 'fluid_mechanics', 'fluid_statics', 'pascals_law', 3, '{"en-us": "A change in pressure applied to an enclosed fluid is transmitted undiminished throughout the fluid."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('percent_yield', '{"en-us": "Percent Yield"}', 'chemistry', 'stoichiometry', NULL, 'percent_yield', 2, '{"en-us": "Percent yield compares the actual product yield to the theoretical maximum yield."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('period_pendulum', '{"en-us": "Simple pendulum period"}', 'physics', 'classical_mechanics', 'oscillations_and_waves', 'harmonic_motion', 3, '{"en-us": "The period of a simple pendulum is proportional to the square root of its length over gravitational acceleration."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('periodic_table', '{"en-us": "Periodic Table"}', 'chemistry', 'general_chemistry', NULL, 'periodic_table', 2, '{"en-us": "The periodic table organises elements by atomic number, electron configuration, and chemical properties."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('photoelectric_effect', '{"en-us": "Photoelectric effect"}', 'physics', 'modern_physics', NULL, 'quantum_mechanics', 4, '{"en-us": "The maximum kinetic energy of ejected electrons equals the photon energy minus the work function."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('plane_geometry', '{"en-us": "Plane Geometry"}', 'mathematics', 'geometry', NULL, 'plane_geometry', 2, '{"en-us": "The area of a triangle equals half the product of its base and height."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('polarization', '{"en-us": "Polarization"}', 'physics', 'optics', 'physical_optics', 'polarization', 2, '{"en-us": "At Brewster''s angle, the tangent of the angle equals the ratio of transmitted to incident refractive indices."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('polygons', '{"en-us": "Polygons"}', 'mathematics', 'geometry', NULL, 'polygons', 2, '{"en-us": "The area of a regular polygon equals half the product of its perimeter and apothem."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('polynomials', '{"en-us": "Polynomials"}', 'mathematics', 'algebra', NULL, 'polynomials', 2, '{"en-us": "A polynomial is an expression consisting of variables and coefficients combined using addition and multiplication."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('potential_energy', '{"en-us": "Potential Energy"}', 'physics', 'classical_mechanics', 'work_and_energy', 'potential_energy', 2, '{"en-us": "Gravitational potential energy equals the product of mass, gravitational acceleration, and height."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('power_formula', '{"en-us": "Power"}', 'physics', 'classical_mechanics', 'work_and_energy', 'power', 2, '{"en-us": "Power equals work divided by time."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('pressure', '{"en-us": "Pressure"}', 'physics', 'fluid_mechanics', 'fluid_statics', 'pressure', 2, '{"en-us": "Pressure equals force divided by area."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('projectile_motion', '{"en-us": "Projectile Motion"}', 'physics', 'classical_mechanics', 'kinematics', 'projectile_motion', 2, '{"en-us": "The horizontal range of a projectile equals the square of its initial velocity divided by gravitational acceleration."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('pythagorean_theorem', '{"en-us": "Pythagorean theorem"}', 'mathematics', 'geometry', NULL, 'triangles', 1, '{"en-us": "In a right triangle, the square of the hypotenuse equals the sum of the squares of the other two sides."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('quadratic_formula', '{"en-us": "Quadratic formula"}', 'mathematics', 'algebra', NULL, 'equations', 2, '{"en-us": "The solutions to a quadratic equation are given by the quadratic formula."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('radioactive_decay', '{"en-us": "Radioactive decay law"}', 'physics', 'modern_physics', NULL, 'nuclear_physics', 4, '{"en-us": "The number of radioactive nuclei decreases exponentially with time."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('reflection', '{"en-us": "Reflection"}', 'physics', 'optics', 'geometrical_optics', 'reflection', 2, '{"en-us": "The angle of incidence equals the angle of reflection."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('reynolds_number', '{"en-us": "Reynolds Number"}', 'physics', 'fluid_mechanics', 'fluid_dynamics', 'reynolds_number', 2, '{"en-us": "The Reynolds number equals density times velocity times characteristic length divided by dynamic viscosity."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('rotational_energy', '{"en-us": "Rotational Energy"}', 'physics', 'classical_mechanics', 'rotational_mechanics', 'rotational_energy', 2, '{"en-us": "Rotational kinetic energy equals half the moment of inertia times angular velocity squared."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('second_law_thermodynamics_clausius', '{"en-us": "Second law of thermodynamics (Clausius statement)"}', 'physics', 'thermodynamics', NULL, 'second_law', 4, '{"en-us": "Heat cannot spontaneously flow from a colder body to a hotter body."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('simple_harmonic_motion', '{"en-us": "Simple harmonic motion position"}', 'physics', 'classical_mechanics', 'oscillations_and_waves', 'harmonic_motion', 3, '{"en-us": "The position of an object in simple harmonic motion varies sinusoidally with time."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('snells_law', '{"en-us": "Snell''s law"}', 'physics', 'optics', 'geometrical_optics', 'refraction', 3, '{"en-us": "The ratio of sines of the angles of incidence and refraction equals the inverse ratio of refractive indices."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('surface_tension', '{"en-us": "Surface Tension"}', 'physics', 'fluid_mechanics', NULL, 'surface_tension', 2, '{"en-us": "Surface tension equals force per unit length acting along a liquid surface."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('suvat_v2', '{"en-us": "SUVAT: v\\u00b2 = u\\u00b2 + 2as"}', 'physics', 'classical_mechanics', 'kinematics', 'constant_acceleration', 3, '{"en-us": "Final velocity squared equals initial velocity squared plus twice acceleration times displacement."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('trig_sin2_cos2', '{"en-us": "Pythagorean trigonometric identity"}', 'mathematics', 'trigonometry', NULL, 'trigonometric_identities', 1, '{"en-us": "The square of the sine plus the square of the cosine equals one."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('wave_equation', '{"en-us": "Universal wave equation"}', 'physics', 'classical_mechanics', 'oscillations_and_waves', 'mechanical_waves', 2, '{"en-us": "The speed of a wave equals its frequency times its wavelength."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('wave_interference', '{"en-us": "Wave Interference"}', 'physics', 'classical_mechanics', 'oscillations_and_waves', 'wave_interference', 2, '{"en-us": "For constructive interference, the path difference equals an integer multiple of the wavelength."}');

INSERT OR IGNORE INTO formula (id, name, science, branch, subbranch, topic, difficulty, description) VALUES  ('work_formula', '{"en-us": "Work done by a force"}', 'physics', 'classical_mechanics', 'work_and_energy', 'work', 2, '{"en-us": "The work done by a force equals the force times the displacement times the cosine of the angle between them."}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
  ('acids_and_bases', 1, 0, 0, 'concentration', '[\mathrm{H}^{+}]');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('angular_momentum', 1, 0, 0, 'moment_of_inertia'),
  ('angular_momentum', 1, 0, 1, 'angular_velocity');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('angular_momentum', 1, 1, 0, 'angular_momentum', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('archimedes_principle', 1, 0, 0, 'density'),
  ('archimedes_principle', 1, 0, 1, 'gravitational_constant'),
  ('archimedes_principle', 1, 0, 2, 'volume');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('archimedes_principle', 1, 1, 0, 'force', -1.0, '{"en-us": "F_b"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('area', 1, 1, 0, 'area', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
('area', 1, 0, 0, 'length', 2.0, '{"en-us": "side"}', '{"en-us": "s"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('atomic_physics', 1, 0, 0, 'frequency');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, latex_prefix, symbol_overwrite) VALUES
('atomic_physics', 1, 1, 0, 'energy', -1.0, '\Delta{}', '{"en-us": "E"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('atomic_structure', 1, 0, 0, 'charge', 0.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('capacitance', 1, 0, 0, 'charge');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('capacitance', 1, 0, 1, 'electric_potential', -1.0),
  ('capacitance', 1, 1, 0, 'capacitance', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('centripetal_acceleration', 1, 0, 0, 'velocity', 2.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
('centripetal_acceleration', 1, 1, 0, 'acceleration', -1.0, '{"en-us": "c"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('centripetal_acceleration', 1, 0, 1, 'length', -1.0, '{"en-us": "r"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('chemical_bonding', 1, 0, 0, 'charge', 0.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label, symbol_overwrite) VALUES
('chemical_equilibrium', 1, 0, 0, 'concentration', '{"en-us": "product"}', '[\mathrm{C}]');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
('chemical_equilibrium', 1, 0, 1, 'concentration', -1.0, '{"en-us": "reactant"}', '[\mathrm{A}]');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('chemical_kinetics', 1, 0, 1, 'rate_constant');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
  ('chemical_kinetics', 1, 0, 0, 'concentration', '[\mathrm{A}]');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('chemical_reactions', 1, 0, 0, 'mass', 0.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, latex_coef) VALUES
  ('circle_area', 1, 0, 0, NULL);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('circle_area', 1, 1, 0, 'area', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('circle_area', 1, 0, 1, 'length', 2.0, '{"en-us": "r"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value) VALUES
  ('circle_circumference', 1, 0, 0, 2.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, latex_coef) VALUES
  ('circle_circumference', 1, 0, 1, NULL);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
('circle_circumference', 1, 0, 2, 'length', '{"en-us": "r"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('circle_circumference', 1, 1, 0, 'length', -1.0, '{"en-us": "C"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, latex_prefix, symbol_overwrite) VALUES
('coordinate_geometry', 1, 0, 0, 'length', '\Delta{}', '{"en-us": "y"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, latex_prefix, symbol_overwrite) VALUES
('coordinate_geometry', 1, 0, 1, 'length', -1.0, '\Delta{}', '{"en-us": "x"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('density_formula', 1, 0, 0, 'mass');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('density_formula', 1, 0, 1, 'volume', -1.0),
  ('density_formula', 1, 1, 0, 'density', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('differential_equations', 1, 0, 0, 'length', 0.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('diffraction', 1, 0, 0, 'wavelength');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, latex_prefix) VALUES
  ('diffraction', 1, 1, 0, 'angle', '\sin');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
('diffraction', 1, 0, 1, 'length', -1.0, '{"en-us": "slit width"}', '{"en-us": "a"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, latex_coef, coeff_exponent) VALUES
  ('einstein_emc2', 1, 0, 1, NULL, 2.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('einstein_emc2', 1, 0, 0, 'mass');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('einstein_emc2', 1, 1, 0, 'energy', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('electric_fields', 1, 0, 0, 'force');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('electric_fields', 1, 0, 1, 'charge', -1.0),
  ('electric_fields', 1, 1, 0, 'electric_field_strength', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value) VALUES
  ('electrochemistry', 2, 0, 0, -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
  ('electrochemistry', 1, 0, 0, 'electric_potential', 'E^\circ_\mathrm{cathode}'),
  ('electrochemistry', 2, 0, 1, 'electric_potential', 'E^\circ_\mathrm{anode}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
  ('electrochemistry', 1, 1, 0, 'cell_potential', -1.0, 'E^\circ_\mathrm{cell}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value) VALUES
  ('electromagnetic_induction', 1, 1, 0, -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('electromagnetic_induction', 1, 0, 0, 'magnetic_flux');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, latex_prefix) VALUES
  ('electromagnetic_induction', 1, 0, 1, 'time', -1.0, '\mathrm{d}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('electromagnetic_waves', 1, 0, 0, 'frequency'),
  ('electromagnetic_waves', 1, 0, 1, 'wavelength');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
('electromagnetic_waves', 1, 1, 0, 'velocity', -1.0, '{"en-us": "wave"}', '{"en-us": "c"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
('entropy', 1, 0, 0, 'heat', '{"en-us": "Q"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, latex_prefix, symbol_overwrite) VALUES
('entropy', 1, 1, 0, 'entropy', -1.0, '\Delta{}', '{"en-us": "S"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('entropy', 1, 0, 1, 'temperature', -1.0, '{"en-us": "T"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value) VALUES
  ('escape_velocity', 1, 0, 0, 2.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('escape_velocity', 1, 0, 1, 'gravitational_constant'),
  ('escape_velocity', 1, 0, 2, 'mass');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('escape_velocity', 1, 1, 0, 'escape_velocity', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('escape_velocity', 1, 0, 3, 'length', -1.0, '{"en-us": "r"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('exponents', 1, 0, 0, 'length', 0.0, '{"en-us": "x"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
('friction', 1, 0, 0, 'force', '{"en-us": "N"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
  ('friction', 1, 1, 0, 'force', -1.0, 'F_\mathrm{f}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('heat', 1, 0, 0, 'mass'),
  ('heat', 1, 0, 1, 'specific_heat_capacity');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, latex_prefix, symbol_overwrite) VALUES
('heat', 1, 0, 2, 'temperature', '\Delta{}', '{"en-us": "T"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('heat', 1, 1, 0, 'heat', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, var_exponent, symbol_overwrite) VALUES
('heat_conduction', 1, 1, 0, -1.0, 'power', -1.0, '{"en-us": "P"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('heat_conduction', 1, 0, 1, 'area');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, latex_prefix, symbol_overwrite) VALUES
('heat_conduction', 1, 0, 2, 'temperature', '\Delta{}', '{"en-us": "T"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
('heat_conduction', 1, 0, 0, 'thermal_conductivity', '{"en-us": "k"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, latex_prefix, symbol_overwrite) VALUES
('heat_conduction', 1, 0, 3, 'length', -1.0, '\Delta{}', '{"en-us": "x"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('heat_engines', 1, 0, 0, 'work');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('heat_engines', 1, 1, 0, 'heat_engine_efficiency', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
('heat_engines', 1, 0, 1, 'heat', -1.0, '{"en-us": "in"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value) VALUES
  ('hookes_law', 1, 0, 0, -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('hookes_law', 1, 0, 1, 'spring_constant'),
  ('hookes_law', 1, 0, 2, 'length');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('hookes_law', 1, 1, 0, 'force', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('impulse', 1, 0, 0, 'force'),
  ('impulse', 1, 0, 1, 'time');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('impulse', 1, 1, 0, 'impulse', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('interference', 1, 0, 1, 'wavelength');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, latex_prefix) VALUES
  ('interference', 1, 0, 0, 'angle', '\sin');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
('interference', 1, 1, 0, 'length', -1.0, '{"en-us": "slit separation"}', '{"en-us": "d"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
('laws_of_sines_and_cosines', 1, 0, 1, 'length', '{"en-us": "b"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, latex_prefix, symbol_overwrite) VALUES
('laws_of_sines_and_cosines', 1, 0, 0, 'angle', -1.0, '\sin', '{"en-us": "A"}'),
('laws_of_sines_and_cosines', 1, 0, 2, 'angle', -1.0, '\sin', '{"en-us": "B"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('laws_of_sines_and_cosines', 1, 1, 0, 'length', -1.0, '{"en-us": "a"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('limiting_reactants', 1, 0, 0, 'amount', 0.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('limits', 1, 0, 0, 'length', 0.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
('mirrors', 1, 0, 0, 'length', -1.0, '{"en-us": "object"}', '{"en-us": "u"}'),
('mirrors', 1, 0, 1, 'length', -1.0, '{"en-us": "image"}', '{"en-us": "v"}'),
('mirrors', 1, 1, 0, 'length', -1.0, '{"en-us": "focal"}', '{"en-us": "f"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('molarity_formula', 1, 0, 0, 'amount');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('molarity_formula', 1, 0, 1, 'volume', -1.0),
  ('molarity_formula', 1, 1, 0, 'concentration', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('moles_from_mass', 1, 0, 0, 'mass');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('moles_from_mass', 1, 0, 1, 'molar_mass', -1.0),
  ('moles_from_mass', 1, 1, 0, 'amount', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('moment_of_inertia', 1, 0, 0, 'mass');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('moment_of_inertia', 1, 1, 0, 'moment_of_inertia', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('moment_of_inertia', 1, 0, 1, 'length', 2.0, '{"en-us": "r"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('momentum_formula', 1, 0, 0, 'mass'),
  ('momentum_formula', 1, 0, 1, 'velocity');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('momentum_formula', 1, 1, 0, 'momentum', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('newtons_law_of_gravitation', 1, 0, 0, 'gravitational_constant');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label) VALUES
('newtons_law_of_gravitation', 1, 0, 1, 'mass', '{"en-us": "1"}'),
('newtons_law_of_gravitation', 1, 0, 2, 'mass', '{"en-us": "2"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('newtons_law_of_gravitation', 1, 0, 3, 'length', -2.0),
  ('newtons_law_of_gravitation', 1, 1, 0, 'force', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('ohms_law', 1, 0, 0, 'current'),
  ('ohms_law', 1, 0, 1, 'resistance');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('ohms_law', 1, 1, 0, 'electric_potential', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, latex_coef, coeff_exponent) VALUES
  ('particle_physics', 3, 0, 1, NULL, 2.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('particle_physics', 1, 1, 0, 'energy', -2.0),
  ('particle_physics', 2, 0, 0, 'momentum', 2.0),
  ('particle_physics', 3, 0, 0, 'mass', 2.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, quantity_id, latex_prefix) VALUES
  ('pascals_principle', 1, 1, 0, -1.0, 'pressure', '\Delta{}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('pascals_principle', 1, 0, 0, 'density'),
  ('pascals_principle', 1, 0, 1, 'gravitational_constant');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, latex_prefix) VALUES
  ('pascals_principle', 1, 0, 2, 'length', '\Delta{}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label) VALUES
('percent_yield', 1, 0, 0, 'amount', '{"en-us": "actual"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
('percent_yield', 1, 0, 1, 'amount', -1.0, '{"en-us": "theoretical"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('periodic_table', 1, 0, 0, 'amount', 0.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_exponent) VALUES
  ('plane_geometry', 1, 0, 0, 2.0, -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label, symbol_overwrite) VALUES
('plane_geometry', 1, 0, 1, 'length', '{"en-us": "base"}', '{"en-us": "b"}'),
('plane_geometry', 1, 0, 2, 'length', '{"en-us": "height"}', '{"en-us": "h"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('plane_geometry', 1, 1, 0, 'area', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label, latex_prefix, symbol_overwrite) VALUES
('polarization', 1, 1, 0, 'angle', '{"en-us": "Brewster"}', '\tan', '\theta_\mathrm{B}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label, symbol_overwrite) VALUES
('polarization', 1, 0, 0, 'refractive_index', '{"en-us": "transmitted"}', '{"en-us": "n_2"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
('polarization', 1, 0, 1, 'refractive_index', -1.0, '{"en-us": "incident"}', '{"en-us": "n_1"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_exponent) VALUES
  ('polygons', 1, 0, 0, 2.0, -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('polygons', 1, 0, 2, 'angle');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label, symbol_overwrite) VALUES
('polygons', 1, 0, 1, 'length', '{"en-us": "side"}', '{"en-us": "s"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('polygons', 1, 1, 0, 'area', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
('polynomials', 3, 0, 0, 'length', '{"en-us": "x"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('polynomials', 4, 0, 0, 'length', 0.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
('polynomials', 2, 0, 0, 'length', 2.0, '{"en-us": "x"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('potential_energy', 1, 0, 0, 'mass');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
('potential_energy', 1, 0, 1, 'acceleration', '{"en-us": "g"}'),
('potential_energy', 1, 0, 2, 'length', '{"en-us": "h"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, quantity_name_overwrite) VALUES
  ('potential_energy', 1, 1, 0, 'energy', -1.0, '{"en-us": "p"}', '{"en-us": "Potential Energy"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('power_formula', 1, 0, 0, 'work');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('power_formula', 1, 0, 1, 'time', -1.0),
  ('power_formula', 1, 1, 0, 'work', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('pressure', 1, 0, 0, 'force');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('pressure', 1, 0, 1, 'area', -1.0),
  ('pressure', 1, 1, 0, 'pressure', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('projectile_motion', 1, 0, 1, 'acceleration', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
('projectile_motion', 1, 0, 0, 'velocity', 2.0, '{"en-us": "initial"}'),
('projectile_motion', 1, 1, 0, 'length', -1.0, '{"en-us": "range"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('pythagorean_theorem', 1, 1, 0, 'length', -2.0),
  ('pythagorean_theorem', 2, 0, 0, 'length', 2.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
('pythagorean_theorem', 3, 0, 0, 'length', 2.0, '{"en-us": "hypotenuse"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
  ('reflection', 1, 0, 0, 'angle', '\theta_\mathrm{r}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, symbol_overwrite) VALUES
  ('reflection', 1, 1, 0, 'angle', -1.0, '\theta_\mathrm{i}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('reynolds_number', 1, 0, 0, 'density'),
  ('reynolds_number', 1, 0, 1, 'velocity'),
  ('reynolds_number', 1, 0, 2, 'length');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('reynolds_number', 1, 0, 3, 'dynamic_viscosity', -1.0),
  ('reynolds_number', 1, 1, 0, 'reynolds_number', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value, coeff_exponent) VALUES
  ('rotational_energy', 1, 0, 0, 2.0, -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('rotational_energy', 1, 0, 1, 'moment_of_inertia');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, quantity_name_overwrite) VALUES
  ('rotational_energy', 1, 0, 2, 'angular_velocity', 2.0, NULL, NULL),
  ('rotational_energy', 1, 1, 0, 'energy', -1.0, '{"en-us": "rot"}', '{"en-us": "Rotational Energy"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label) VALUES
('snells_law', 2, 0, 0, 'refractive_index', '{"en-us": "2"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, label, latex_prefix) VALUES
('snells_law', 2, 0, 1, 'angle', '{"en-us": "r"}', '\sin');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
('snells_law', 1, 1, 0, 'refractive_index', -1.0, '{"en-us": "1"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, latex_prefix) VALUES
('snells_law', 1, 1, 1, 'angle', -1.0, '{"en-us": "i"}', '\sin');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('surface_tension', 1, 0, 0, 'force');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('surface_tension', 1, 0, 1, 'length', -1.0),
  ('surface_tension', 1, 1, 0, 'surface_tension', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, coeff_value) VALUES
  ('suvat_v2', 3, 0, 0, 2.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('suvat_v2', 3, 0, 1, 'acceleration');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, symbol_overwrite) VALUES
('suvat_v2', 3, 0, 2, 'length', '{"en-us": "r"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label) VALUES
('suvat_v2', 1, 1, 0, 'velocity', -2.0, '{"en-us": "final"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, label, symbol_overwrite) VALUES
('suvat_v2', 2, 0, 0, 'velocity', 2.0, '{"en-us": "initial"}', '{"en-us": "u"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('wave_equation', 1, 0, 0, 'frequency'),
  ('wave_equation', 1, 0, 1, 'wavelength');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('wave_equation', 1, 1, 0, 'velocity', -1.0);

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('wave_interference', 1, 0, 0, 'wavelength');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent, latex_prefix, symbol_overwrite) VALUES
('wave_interference', 1, 1, 0, 'path_difference', -1.0, '\Delta', '{"en-us": "x"}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id) VALUES
  ('work_formula', 1, 0, 0, 'force'),
  ('work_formula', 1, 0, 1, 'length');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, latex_suffix) VALUES
  ('work_formula', 1, 0, 2, 'angle', '{}');

INSERT OR IGNORE INTO formula_item (formula_id, term, is_primary, sort_order, quantity_id, var_exponent) VALUES
  ('work_formula', 1, 1, 0, 'work', -1.0);