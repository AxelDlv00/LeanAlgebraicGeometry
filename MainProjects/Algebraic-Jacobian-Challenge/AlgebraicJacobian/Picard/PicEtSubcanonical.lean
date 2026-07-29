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
  After it, no supplementary étale-representability theorem is needed: `picEt`
  representability follows from `picSharp` representability by `Subcanonical` +
  `isIso_toSheafify`, both already in Mathlib.

**But the antecedent must not be read as reachable over `k`, and §4 is why.**
The same subcanonicity that powers the transport also proves that a
representable `picSharp` is a *Zariski* sheaf
(`PicScheme.picSharp_isSheaf_zariski_of_representableBy`). Kleiman §2
(L1292–L1302) exhibits a curve over a field for which `picSharp` is **not** a
Zariski sheaf. Contrapositive: representability of `picSharp C` over an
arbitrary field is **false in general**, not merely unproved. So the campaign
milestones that conclude representability of `picSharp`/`picSharpDeg` over `k`
itself — G3 (Galois descent of `picSharp` points) and G4 (the coproduct
assembly) — aim at a statement that cannot be proved as written.

This is not an argument against the Milne–Kollár route. Everything through J5
runs over a separably closed `k'`, where a section is available and the
obstruction is absent; the break is precisely at the descent step where the
conclusion returns to `k`. The repair the results here name is that the object
descended to `k` must be `picEt`, which *has* the sheaf property that carries
descent, and not `picSharp`, which lacks it. Over `k'` the two agree, by
`isIso_picEtComparison_of_isSheaf` applied to the representability available
there — so J5's output is already a `picEt`-representing scheme after base
change.

What is **not** established here: that Kleiman's non-sheaf example satisfies
this project's binders (smooth, proper, geometrically integral) — it is quoted
from the reference, not formalised — and no restated G3. The Lean content of §4
is exactly the implication "representable ⇒ Zariski sheaf"; the falsity of the
antecedent is a consequence *given* the quoted counterexample.

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
* `Scheme.PicScheme.picSharp_isSheaf_zariski_of_representableBy` — §4: a
  representable `picSharp` is a Zariski sheaf, the implication whose
  contrapositive limits what the campaign's descent step may target.

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

/-! ## §3. The transport, with no rational point anywhere -/

/-- **The transport: a scheme representing `picSharp C` also represents
`picEt C`, with no hypothesis on `C(k)`.**

This is the statement the seam docstring and the board row `AJC.picrep.etale-rep`
declare impossible without a section. The proof composes §1 and §2: the
representing scheme makes `relPresheaf C` an étale sheaf
(`relPresheaf_isSheaf_of_representableBy`, i.e. subcanonicity), being a sheaf
makes the sheafification unit an isomorphism
(`isIso_picEtComparison_of_isSheaf`), and `Functor.RepresentableBy.ofIso`
carries the representation across it.

Note what is and is not proved. `X` is *given* here — the theorem consumes
`picSharp` representability rather than producing it, and that antecedent is
exactly the undischarged output of the Milne–Kollár campaign. What the theorem
establishes is that no *further* representability theorem is needed on top of
the campaign, contradicting the "eleventh item" pricing. -/
noncomputable def picSharp_representableBy_picEt_transport {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (PicScheme.picSharp C).RepresentableBy X) :
    (PicScheme.picEt C).RepresentableBy X :=
  rep.ofIso (@asIso _ _ _ _ (PicScheme.picEtComparison C)
    (PicScheme.isIso_picEtComparison_of_isSheaf C
      (PicScheme.relPresheaf_isSheaf_of_representableBy C rep)))

/-- **Clause (1) of the seam follows from its `picSharp` analogue.**

Same content as `picSharp_representableBy_picEt_transport`, packaged in the
seam's own existential shape so the comparison with
`Scheme.fgaPicardRepresentability` is direct: the local-finiteness and
separatedness conjuncts are carried across unchanged, because the transport
does not move the representing scheme — it is the *same* `X`.

The hypothesis is stated as the `picSharp`-shaped existential rather than as
`[HasPicScheme C]`, deliberately: `HasPicScheme` pins the witness to
`PicScheme C` and has no instance, so quantifying over it would make this
theorem consume an uninhabited class. Here the witness is universally
quantified and the statement is a genuine implication. -/
theorem hasPicSchemeEt_of_picSharp_representability {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (h : ∃ X : Over (Spec (CommRingCat.of k)),
        Nonempty ((PicScheme.picSharp C).RepresentableBy X) ∧
          LocallyOfFiniteType X.hom ∧ IsSeparated X.hom) :
    ∃ X : Over (Spec (CommRingCat.of k)),
      Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
        LocallyOfFiniteType X.hom ∧ IsSeparated X.hom := by
  obtain ⟨X, ⟨rep⟩, hft, hsep⟩ := h
  exact ⟨X, ⟨picSharp_representableBy_picEt_transport C rep⟩, hft, hsep⟩

/-- **Clause (2) follows too, and unconditionally** — which is strictly stronger
than the seam's own second conjunct `HasRationalPoint C → IsIso …`.

Given representability of `picSharp C`, the comparison
`PicScheme.picEtComparison C` is an isomorphism outright, with no section. So
under the campaign's endpoint the rational-point hypothesis of Kleiman §2
Thm 2.5 becomes redundant *for this curve*: it was buying a sheaf property that
representability already supplies.

This is not a proof of Kleiman 2.5 — that theorem asserts the comparison is an
isomorphism from the section alone, with no representability input, and remains
unformalised. -/
theorem isIso_picEtComparison_of_picSharp_representability {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (PicScheme.picSharp C).RepresentableBy X) :
    IsIso (PicScheme.picEtComparison C) :=
  PicScheme.isIso_picEtComparison_of_isSheaf C
    (PicScheme.relPresheaf_isSheaf_of_representableBy C rep)

/-! ## §4. The limit on the antecedent: representable implies *Zariski* sheaf

The transport of §3 says the campaign needs no supplementary étale
representability theorem. This section says where the campaign may not put its
conclusion, and the two together are what actually price the board row.

Attribution: this direction was pointed out by `review-ajc` on the §1–§3
commit, as a corollary of `relPresheaf_isSheaf_of_representableBy`. -/

namespace PicScheme

/-- **A representable `picSharp` is a Zariski sheaf.**

Immediate from subcanonicity of the *Zariski* topology on `(Sch/k)`
(`Scheme.subcanonical_zariskiTopology` through
`GrothendieckTopology.subcanonical_over`) — the étale route of §1 is not even
needed, though `zariskiTopologyOver_le_etaleTopologyOver` (`Picard/PicEtSheaf.lean`)
would also transport it from there.

**What this rules out.** The seam docstring
(`Picard/FGAPicRepresentability.lean`, "Why sheafifying is what makes an
unconditional statement possible") argues *in prose* that an unconditional
`RepresentableBy` against `picSharp` is FALSE rather than unproved, because
Kleiman §2 (L1292–L1302) gives a curve whose `picSharp` is not a Zariski sheaf
while a representable functor is a sheaf for any subcanonical topology. This
theorem is the second half of that argument, as a Lean statement rather than as
prose. Its contrapositive therefore says: over an arbitrary field, no scheme
represents `picSharp C` in general.

The campaign milestones G3 and G4 conclude exactly that (G3: `J_r := J'_r/Γ`
represents `picSharpDeg C r` over `k`; G4 assembles `picSharpDeg`), so they are
targeting a false statement as written and need restating against `picEt`. That
restatement is the content of the board row `AJC.picrep.etale-rep`, and it is
what makes the row a *route repair* rather than a missing theorem.

**Not formalised, and deliberately named as such**: that Kleiman's non-sheaf
curve is smooth, proper and geometrically integral — this project's binders. It
is quoted from the reference. Without that check the theorem below is a true
implication whose antecedent has not been *proved* uninhabitable, only reported
so by Kleiman. -/
theorem picSharp_isSheaf_zariski_of_representableBy {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (picSharp C).RepresentableBy X) :
    Presieve.IsSheaf (Scheme.zariskiTopology.over (Spec (CommRingCat.of k)))
      (picSharp C) := by
  haveI : (picSharp C).IsRepresentable := ⟨X, ⟨rep⟩⟩
  exact GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable _

end PicScheme

end Scheme

end AlgebraicGeometry
