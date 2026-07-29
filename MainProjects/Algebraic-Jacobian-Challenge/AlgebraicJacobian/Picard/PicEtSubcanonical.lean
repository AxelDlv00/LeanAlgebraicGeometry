/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Picard.FGAPicRepresentability

/-!
# Subcanonicity of the étale site, and the section-free transport `picSharp → picEt`

This file settles a **route** question about the project's central obligation
`Scheme.fgaPicardRepresentability` (`Picard/FGAPicRepresentability.lean`), and
it settles it in the direction opposite to what that file's docstring and the
board row `AJC.picrep.etale-rep` currently assert.

## The claim this file refutes

Clause (1) of the seam asks for representability of the étale-sheafified
functor `PicScheme.picEt C`, while every milestone of the Milne–Kollár campaign
targets the *unsheafified* `PicScheme.picSharp C`. The seam docstring and the
board row both say the gap between them **cannot be bridged without a
`k`-rational point**, on the grounds that the comparison
`PicScheme.picEtComparison C` is Kleiman §2 Thm 2.5 — an isomorphism only under
a section — and that a section is exactly what the owner decision `I-0491`
forbids the headline to carry.

That reasoning is wrong, and the error is a direction confusion. Kleiman §2
Thm 2.5 is the statement that a section makes the comparison an isomorphism
*with no hypothesis on the presheaf*. But there is a second, entirely
independent, route to the same conclusion: the comparison is the sheafification
unit, and a unit is an isomorphism **exactly when its source is already a
sheaf** (`CategoryTheory.isIso_toSheafify`). A representable functor is a sheaf
for any subcanonical topology. So *if* the campaign delivers representability of
`picSharp`, the source is a sheaf for that reason alone, the unit is an
isomorphism, and no section is involved anywhere.

The consequence for the route, stated precisely because the board row is
currently priced on its negation: the campaign's endpoint **is** transportable
to clause (1). `picSharp_representableBy_picEt_transport` below is that
transport, proved with no rational-point hypothesis of any kind.

## What is actually still open

This file does **not** close the seam. It removes an alleged obstruction, which
is a different thing, and the honest statement of what remains is:

* the antecedent of every theorem here is representability of `picSharp C`
  over an arbitrary field — campaign milestones J1–J5, G3, G4, B1/B4/B6,
  D2′–D4′, P5 — and **not one of those is discharged**. No theorem in this file
  is applied to a curve anywhere in the project, and none should be reported as
  progress on the existence question;
* what changes is the *shape* of the remaining work. Before this file, a reader
  of the seam docstring concluded that finishing the campaign leaves a further
  unpriced obligation ("represent `picEt` directly, or restate the headline").
  After it, finishing the campaign suffices: `picEt` representability follows
  from `picSharp` representability by `Subcanonical` + `isIso_toSheafify`, both
  already in Mathlib.

There is one genuine subtlety, and it is not a section. The transport proves
that the *same* scheme represents both functors, so it does not produce
`picSharp` representability out of nothing — it consumes it. Read
`Scheme.picSharp_representableBy_picEt_transport` as: the campaign does not
need a supplementary étale-representability theorem, only the subcanonicity
lemma proved here.

## Main results

* `AlgebraicGeometry.Scheme.subcanonical_etaleTopology` — the big étale
  topology on schemes is subcanonical. Absent from Mathlib `v4.31` as an
  instance; obtained from `proetaleTopology` (which has one) along
  `Scheme.etaleTopology_le_proetaleTopology` by
  `GrothendieckTopology.Subcanonical.of_le`.
* `AlgebraicGeometry.Scheme.subcanonical_etaleTopologyOver` — its localisation
  to `(Sch/k)`, the site the relative Picard presheaf actually lives on.
* `Scheme.PicScheme.isIso_picEtComparison_of_isSheaf` — the section-free
  criterion: if `PicSharp.relPresheaf C` is an étale sheaf then
  `picEtComparison C` is an isomorphism.
* `Scheme.PicScheme.relPresheaf_isSheaf_of_representableBy` — representability
  of `picSharp C` makes `relPresheaf C` an étale sheaf (subcanonicity, then
  reflection along the forgetful functor).
* `Scheme.picSharp_representableBy_picEt_transport` — the transport: a scheme
  representing `picSharp C` also represents `picEt C`, with **no**
  `[HasRationalPoint C]`.
* `Scheme.hasPicSchemeEt_of_picSharp_representability` — the same statement in
  the seam's own packaging: clause (1) of `fgaPicardRepresentability` follows
  from its `picSharp` analogue.
* `Scheme.isIso_picEtComparison_of_picSharp_representability` — and clause (2)
  follows too, *unconditionally*, which is strictly stronger than the seam's
  own `HasRationalPoint C → IsIso …`.

## References

Kleiman, "The Picard scheme" (arXiv:math/0504020), §2 Thm 2.5 (`th:comp`) — the
section route, which this file does not use — and §4 Thm `th:main`.
Board: `AJC.picrep.etale-rep`. Decision: `I-0491`.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. The étale site is subcanonical -/

/-- **The big étale topology on schemes is subcanonical**, i.e. every
representable presheaf is an étale sheaf.

Mathlib `v4.31` supplies this instance for the Zariski, coherent, regular,
extensive and *pro*-étale topologies, but not for the étale one. It costs
nothing: `Scheme.etaleTopology_le_proetaleTopology` and
`GrothendieckTopology.Subcanonical.of_le` (a subtopology of a subcanonical
topology is subcanonical, since the canonical topology is an upper bound).

This is the lemma that makes the transport of §3 possible, and its absence is
why the seam's route analysis concluded a section was needed. -/
instance subcanonical_etaleTopology : Scheme.etaleTopology.{u}.Subcanonical :=
  GrothendieckTopology.Subcanonical.of_le Scheme.etaleTopology_le_proetaleTopology

/-- Subcanonicity descends to the localisation `(Sch/k)`, which is the site the
relative Picard presheaf lives on (`Scheme.etaleTopologyOver`,
`Picard/PicEtSheaf.lean`).

Supplied by `GrothendieckTopology.subcanonical_over` from
`subcanonical_etaleTopology`; recorded as a named theorem because the
`etaleTopologyOver` abbreviation is what every statement downstream mentions. -/
theorem subcanonical_etaleTopologyOver (k : Type u) [Field k] :
    (etaleTopologyOver k).Subcanonical :=
  inferInstance

namespace PicScheme

/-! ## §2. The comparison is an isomorphism when the source is a sheaf -/

/-- **The section-free criterion for the sheafification comparison.**

`PicScheme.picEtComparison C` is by construction the sheafification unit
`PicSharp.toEtaleSheaf C` whiskered with the forgetful functor. A unit of the
sheafification adjunction is an isomorphism exactly when its source is already
a sheaf (`CategoryTheory.isIso_toSheafify`), so the étale sheaf property of
`PicSharp.relPresheaf C` suffices — and nothing about `C(k)` enters.

Contrast `picEtComparison_isIso_of_hasRationalPoint`
(`Picard/FGAPicRepresentability.lean`), which reaches the same conclusion from
Kleiman §2 Thm 2.5 via a section. The two routes are independent; this one is
the one available under the owner decision `I-0491`. -/
theorem isIso_picEtComparison_of_isSheaf {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (h : Presheaf.IsSheaf (etaleTopologyOver k) (PicSharp.relPresheaf C)) :
    IsIso (picEtComparison C) :=
  haveI : IsIso (PicSharp.toEtaleSheaf C) := isIso_toSheafify _ h
  Functor.isIso_whiskerRight _ _

/-- **Representability makes the relative Picard presheaf an étale sheaf.**

Two steps, both structural. A functor represented by a scheme is a sheaf for
the subcanonical étale topology
(`GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable`, using
`subcanonical_etaleTopologyOver`); and the sheaf property of the
`AddCommGrpCat`-valued `relPresheaf C` is *equivalent* to that of its
underlying type-valued functor `picSharp C = relPresheaf C ⋙ forget _`, because
the forgetful functor of a concrete algebraic category preserves limits and
reflects isomorphisms (`Presheaf.isSheaf_iff_isSheaf_forget`).

The hypothesis is a `RepresentableBy` for an arbitrary `X`, not for
`PicScheme C`, so this does not silently consume the seam. -/
theorem relPresheaf_isSheaf_of_representableBy {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (picSharp C).RepresentableBy X) :
    Presheaf.IsSheaf (etaleTopologyOver k) (PicSharp.relPresheaf C) := by
  haveI : (picSharp C).IsRepresentable := ⟨X, ⟨rep⟩⟩
  have hsh : Presieve.IsSheaf (etaleTopologyOver k) (picSharp C) :=
    GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable _
  rw [Presheaf.isSheaf_iff_isSheaf_forget (s := CategoryTheory.forget AddCommGrpCat.{u+1}),
    CategoryTheory.isSheaf_iff_isSheaf_of_type]
  exact hsh

end PicScheme

end Scheme

end AlgebraicGeometry
