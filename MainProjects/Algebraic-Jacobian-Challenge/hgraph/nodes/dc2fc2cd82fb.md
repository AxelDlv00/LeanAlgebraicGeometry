---
author: sync
chapter: 'The Grassmannian over $\mathbb{Z}$: affine charts and gluing'
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:gr_cocycle_theta_ij
lean_status: empty
order: 1369
title: 'Localised transition map \(\Theta_{I,J} : S_J \to S_I\)'
type: tex
updated: '2026-07-24T10:32:51'
---
The triple-overlap transition map
  \(\Theta_{I,J} : S_J = R^J[1/(P^J_I P^J_K)] \to S_I = R^I[1/(P^I_J P^I_K)]\):
  the away-localisation lift (\cref{lem:mathlib_away_lift}) along the doubly
  inverted minor \(P^J_I P^J_K\) of the pre-hom \(\tilde\theta_{I,J}\)
  (\cref{def:gr_transition_pre}) post-composed with the inclusion
  \(\iota^{\mathrm{L}}\) into \(S_I\) (\cref{def:gr_away_incl_left}). It is
  well-defined because both inverted minors map to units of \(S_I\):
  \(\tilde\theta_{I,J}(P^J_I)\) by \cref{lem:gr_transition_pre_unit} (then
  \cref{lem:gr_awayInclLeft_comp_algebraMap}), and \(\tilde\theta_{I,J}(P^J_K)\)
  by \cref{lem:gr_isUnit_incl_transitionPreMap_cross} (with cross factor
  \(P^I_K\) a unit, \cref{lem:gr_isUnit_algebraMap_away_right}).