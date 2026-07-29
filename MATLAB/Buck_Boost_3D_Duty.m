%% Conception de l'Inductance L1 : Comparaison Step-up vs Step-down
clear; clc; close all;

% --- Paramètres du Projet ---
fs = 50e3;          % Fréquence de découpage (50 kHz) [cite: 7929]
V_LV = 24;          % Tension Basse Tension (24 V) [cite: 8310]
V_HV = 300;         % Tension Haute Tension (300 V) [cite: 8309]
Pout = 300;         % 500 W
Io_up = Pout/V_HV;  % Courant de sortie (Step-up)
Io_down = Pout/V_LV;% Courant de sortie (Step-down)

% --- Grilles de calcul (Duty Cycle et Ondulation) ---
D = linspace(0.1, 0.85, 60);
delta_i = linspace(0.1, 2, 60);  % Ripple de courant en Ampères [cite: 7929]
delta_v = linspace(1, 10, 60);
[Dg, DI] = meshgrid(D, delta_i);
[Dg_v, DV] = meshgrid(D, delta_v);

% --- CALCULS MODE STEP-UP (CUBIQUE - BLEU) ---
% Équations basées sur le gain 1/(1-D)^3
% L1_p = (V_LV .* Dg) ./ (DI * fs);
% L2_p = ((V_LV ./ (1-Dg)) .* Dg) ./ (DI * fs);
% L3_p = ((V_LV ./ (1-Dg).^2) .* Dg) ./ (DI * fs);
% C1_p = (Io_up ./ (1-Dg_v) .* Dg_v) ./ (DV * fs);
% C2_p = (Io_up ./ (1-Dg_v).^2 .* Dg_v) ./ (DV * fs);
% CH_up = (Io_up .* Dg) ./ (DV * fs); 
% CL_up = (Io_up ./ (1-Dg).^3 .* Dg) ./ (DV * fs);
% % --- CALCULS MODE STEP-DOWN (CUBIQUE - ROUGE) ---
% % Équations basées sur le gain D^3
% L3_d = ((V_HV - Dg.*V_HV) .* Dg) ./ (DI * fs);
% L2_d = ((Dg.*V_HV - Dg.^2.*V_HV) .* Dg) ./ (DI * fs);
% L1_d = ((Dg.^2.*V_HV - Dg.^3.*V_HV) .* Dg) ./ (DI * fs);
% C2_d = (Io_down .* (1-Dg_v) .* Dg_v) ./ (DV * fs);
% C1_d = (Io_down .* (1-Dg_v) .* Dg_v) ./ (DV * fs);
% CL_down = (Io_down .* (1-Dg)) ./ (8 * 1e-3 * DV * fs^2); % Formule Buck standard (L=1mH)
% CH_down = (Io_down .* Dg.^3 .* Dg) ./ (DV * fs);

% --- 1. Calcul Mode Step-Up (Bleu) ---
% Equation issue de votre projet pour L1 en magnétisation
L1_up =(V_LV .* Dg) ./ (DI * fs);

% --- 2. Calcul Mode Step-Down (Rouge) ---
% Equation issue de votre projet (Gain cubique D^3)
L1_down =((Dg.^2.*V_HV - Dg.^3.*V_HV) .* Dg) ./ (DI * fs);

% --- 3. Affichage du Graphique ---
fig = figure('Name', 'Design Inductance L3', 'Color', 'w');
ax = axes(fig);

% Appel de la fonction de tracé
tracer_surfaces_L1(ax, Dg, DI, L1_up, L1_down);

% Activation du curseur de données interactif
dcm = datacursormode(fig);
set(dcm, 'UpdateFcn', @generer_etiquette);

disp('Graphique généré. Utilisez le curseur pour lire les points (D, Ripple, Valeur).');

%% --- FONCTIONS LOCALES (À placer à la fin du fichier .m) ---

function tracer_surfaces_L1(ax, x, y, z_up, z_down)
    % Tracé Step-up en Bleu
    surf(ax, x, y, z_up*1e3, 'FaceColor', 'b', 'FaceAlpha', 0.5, 'EdgeColor', 'none'); 
    hold(ax, 'on');
    
    % Tracé Step-down en Rouge
    surf(ax, x, y, z_down*1e3, 'FaceColor', 'r', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    
    % Mise en forme esthétique (Style IEEE Access)
    title(ax, 'Inductor L_3 Design Surface');
    xlabel(ax, 'Duty Cycle (D)');
    ylabel(ax, 'Voltage Ripple \Delta i_{L1} (A)');
    zlabel(ax, 'Inductor (mH)');
    grid(ax, 'on');
    view(ax, 135, 30); % Angle de vue similaire à l'article [cite: 7909]
    legend(ax, {'Step-up mode', 'Step-down mode'}, 'Location', 'northeast');
end

function txt = generer_etiquette(~, event_obj)
    % Personnalisation de l'affichage des données au clic
    pos = event_obj.Position;
    txt = {['Duty Cycle (D): ', num2str(pos(1), 4)], ...
           ['Ripple (V): ', num2str(pos(2), 4)], ...
           ['L1 Value (mH): ', num2str(pos(3), 4)]};
end