---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:sheafModule_monoidalStructure
lean_status: lean_ok
order: 1279
title: Symmetric monoidal structure on sheaves of modules by transport
type: tex
updated: '2026-07-27T15:50:36'
---
For a scheme \(X\), the category \(X.\Modules\) of sheaves of
  \(\mathcal{O}_X\)-modules carries a symmetric monoidal structure obtained by
  transporting the symmetric monoidal structure of \(X.\PshMod\) along the
  sheafification functor. Concretely, one instantiates the monoidal localization
  transport \cref{lem:monoidalLocalization_mathlib} with source the symmetric
  monoidal category \(X.\PshMod\), localization functor the module sheafification
  \cref{lem:moduleSheafification_isLocalization_mathlib}, and the
  tensor-compatibility of its inverted class \cref{def:sheafModule_W_isMonoidal};
  the unit is chosen to be the unit module \(\mathbf{1}_X\) (\cref{def:unitModule}).
  The resulting tensor product agrees objectwise with the sheaf tensor product
  \cref{def:sheafTensorObj}, via the strong-monoidal comparison
  \(\mu\) of \cref{lem:monoidalLocalization_mathlib}. In particular the associator
  is the canonical (Mac Lane) associator, the pentagon and triangle laws hold, and
  --- the source being symmetric --- the braiding and its hexagon laws are
  inherited as well, giving \(X.\Modules\) the structure of a
  \emph{symmetric monoidal category}.