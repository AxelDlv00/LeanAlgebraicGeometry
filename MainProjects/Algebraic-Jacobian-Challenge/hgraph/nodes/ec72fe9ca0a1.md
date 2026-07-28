---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:sectionGradedRing_gmonoid
lean_status: lean_ok
order: 1345
title: Graded monoid structure on the section components
type: tex
updated: '2026-07-28T22:30:28'
---
Let \(\mathcal{L}\) be an arbitrary sheaf of \(\mathcal{O}_X\)-modules. The degree
  family \(\mathrm{sectionDeg}\,\mathcal{L}\), \(m \mapsto
  \Gamma(X,\mathcal{L}^{\otimes m})\), equipped with the graded multiplication
  \(\mathrm{gMul}\) (\cref{def:sectionGradedGMul}) and graded unit \(\mathrm{gOne}\)
  (\cref{def:sectionGradedGOne}), is a graded monoid (a
  \(\mathrm{GradedMonoid.GMonoid}\) on \(\mathrm{sectionDeg}\,\mathcal{L}\)).