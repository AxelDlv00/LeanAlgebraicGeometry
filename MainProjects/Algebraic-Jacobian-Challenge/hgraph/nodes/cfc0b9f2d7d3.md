---
author: sync
content_type: theorem
created: '2026-07-28T13:22:16'
decl: AlgebraicGeometry.Scheme.fgaPicardRepresentability
docstring: "**THE PROJECT'S CENTRAL OPEN OBLIGATION — expected to stay open.**\n\n\
  Kleiman §4 Thm `th:main` + Cor `cor:algsch`: for a smooth proper geometrically\n\
  integral curve `C` over an *arbitrary* field `k`, the **étale-sheafified**\nrelative\
  \ Picard functor `Pic_{(C/k)ét}` (`PicScheme.picEt`,\n`Picard/PicEtSheaf.lean`)\
  \ is representable by a `k`-scheme that is separated\nand locally of finite type\
  \ — a disjoint union of open quasi-projective\n`k`-subschemes. All three conjuncts\
  \ are parts of that one theorem, which is\nwhy they are bundled.\n\n**There is no\
  \ hypothesis on `C(k)`, and that is the point.** This statement is\nthe one the\
  \ challenge asks for: `AlgebraicJacobian/Challenge.lean` binds\n`Jacobian C` for\
  \ a curve with no rational point, so a representability input\ncarrying `[HasRationalPoint\
  \ C]` answers a different question. The conditional\nform survives beside this one\
  \ as `picSchemeOfHasRationalPoint` below, clearly\nlabelled as strictly weaker.\n\
  \n**Why sheafifying is what makes an unconditional statement possible.** The\nunsheafified\
  \ functor `picSharp C = T ↦ Pic(C ×_k T)/π_T^* Pic(T)` is *not*\nrepresentable over\
  \ a general field — it is not even a Zariski sheaf (Kleiman §2\nL1292–L1302), and\
  \ a representable functor is a sheaf for any subcanonical\ntopology. So an unconditional\
  \ `RepresentableBy` against `picSharp` would be a\nFALSE statement, not merely an\
  \ unproved one. Against `picEt` it is Kleiman's own\ntheorem. `PicScheme.picEt_isSheaf_forget`\
  \ records the sheaf property that makes\nthe difference, and it is proved rather\
  \ than assumed.\n\n**Expected to stay open, and that is the honest state rather\
  \ than a defect.**\nThe project reaches this statement rather than proving it, and\
  \ it is the single\nnamed `sorry` that the whole Jacobian headline rests on. Do\
  \ not replace it with\na weaker conditional statement to make a count go down.\n\
  \n**Which route discharges it — corrected 2026-07-29 (`review-ajc`), because the\n\
  previous text named the inputs of a route this project does not take.** That\ntext\
  \ said the inputs are `Div` representability \"which needs the Quot scheme\"\n(Kleiman\
  \ §3 Thm `th:repDiv`) together with the Altman–Kleiman quotient lemma\n`smoothProperQuotient`.\
  \ Both belong to the **Grothendieck/Kleiman quotient\nroute**, which is `rejected`\
  \ on the board (`AJC.picrep.quot`,\n`AJC.picrep.serre`) — so a reader who trusted\
  \ this docstring concluded, wrongly,\nthat the seam's own inputs had been abandoned.\n\
  \nThe committed route is **Milne–Kollár** (`informal/pic-representability-campaign.md`,\n\
  alternative D3), and it needs neither:\n\n* `Div^d` representability comes through\
  \ the **Grassmannian**, not Quot:\n  degree slices of `Scheme.DivFunctor` (`Picard/DivDegree.lean`,\
  \ landed), an\n  embedding into `Scheme.Grassmannian` of the section module, locally\
  \ closed\n  carving, and `Grassmannian.representable`\n  (`Picard/GrassmannianRepresentability.lean`,\
  \ proved) — campaign milestones\n  D1′–D4′. D4′ also delivers the locally closed\
  \ immersion into `Gr` that serves\n  as the quasi-projectivity certificate.\n* the\
  \ quotient is the **finite Galois** quotient of a semilinear action whose\n  finite\
  \ orbits lie in affine opens — campaign G2, in\n  `Picard/FiniteGaloisQuotient.lean`\
  \ (`sorry`-free) with Speiser descent under\n  `Picard/GaloisDescent/`. It is *not*\
  \ `smoothProperQuotient`, which is false as\n  stated in Lean (see the §4 note below)\
  \ and must not be built against.\n  **`sorry`-free is not gate-free here**: the\
  \ affine case is proved\n  (`isGaloisQuotientSpec`, `Picard/FiniteGaloisQuotientAffine.lean`)\
  \ and the\n  gluing substrate exists, but the general existence statement is still\
  \ the\n  instance-free class `HasGaloisQuotient` (`FiniteGaloisQuotient.lean`),\
  \ whose\n  only producer is a single-field non-vacuity witness\n  (`Picard/GaloisQuotientNonVacuity.lean`).\
  \ So G2 is *substantially* built, not\n  discharged.\n\nWhat remains is those campaign\
  \ modules — uniform `H¹` vanishing (P5, the open\n`AJC.rr.extuniform` leaf), the\
  \ `picSharp` Zariski-sheaf/degree/separatedness\ndevices (B1, B4, B6), the `Div^d`\
  \ chain (D2′–D4′), the Milne glue over a\nseparably closed field (J1–J5, which also\
  \ needs a universe bridge since\n`picSharp` is `Type (u+1)`-valued while Mathlib's\
  \ 01JJ engine wants `Type u`),\nGalois descent of `picSharp` points (G3), and the\
  \ coproduct assembly (G4) —\n**plus one further item that no campaign milestone\
  \ covers**, recorded next.\n\n**THE ELEVENTH ITEM — every campaign milestone targets\
  \ `picSharp`, while clause\n(1) above is about `picEt`. CORRECTED 2026-07-29 (`ajc-p1`):\
  \ the gap is a route\nrepair, NOT a missing representability theorem.** The campaign\n\
  (`informal/pic-representability-campaign.md`) was written on 2026-07-09 for the\n\
  `picSharp`-shaped obligation, before the étale decision of 2026-07-28\n(protection\
  \ `I-0491`). Its J-cluster represents `picSharpDeg C' r`, G3 descends\n`picSharp`\
  \ points, and G4 assembles `picSharpDeg`; the word `picEt` does not\noccur in any\
  \ milestone body.\n\nThe previous text here concluded that the gap \"cannot be closed\
  \ by composing\nwith `picEtComparison`\", because that comparison is an isomorphism\
  \ only under a\nsection (Kleiman §2 Thm 2.5), and hence that representability of\
  \ the sheafified\nfunctor is a *genuine additional obligation*. **That inference\
  \ was wrong**, and\nit is a direction confusion. Kleiman 2.5 makes the comparison\
  \ an isomorphism\nfrom a section with no hypothesis on the presheaf; but the comparison\
  \ is the\nsheafification *unit*, and a unit is an isomorphism exactly when its source\
  \ is\nalready a sheaf — and a representable functor is a sheaf for any subcanonical\n\
  topology. `Picard/PicEtSubcanonical.lean` proves this chain\n(`subcanonical_etaleTopology`,\
  \ absent from Mathlib `v4.31` for the étale\ntopology but free from `proetaleTopology`),\
  \ and\n`picSharp_representableBy_picEt_transport` transports a `picSharp`\nrepresentation\
  \ to a `picEt` one with **no** rational-point hypothesis, the same\nscheme serving\
  \ both. So no supplementary étale-representability theorem is\nneeded.\n\n**What\
  \ the correction costs instead, and it is a sharper constraint.** The same\nsubcanonicity\
  \ proves that a representable `picSharp` is a *Zariski* sheaf\n(`PicScheme.picSharp_isSheaf_zariski_of_representableBy`),\
  \ and the\nsheafification paragraph above records that Kleiman §2 (L1292–L1302)\
  \ exhibits a\ncurve whose `picSharp` is not one. Contrapositive: representability\
  \ of `picSharp`\nover an arbitrary field is FALSE, so **G3 and G4 target a false\
  \ statement as\nwritten**, not a hard one. Everything through J5 runs over a separably\
  \ closed\n`k'` where a section is available and the obstruction absent; the break\
  \ is the\ndescent step where the conclusion returns to `k`, and the repair is that\
  \ the\nobject descended must be `picEt` (which has the sheaf property that carries\n\
  descent) rather than `picSharp`. Over `k'` the two agree. Restating G3/G4 that\n\
  way reaches clause (1) with no false intermediate.\n\nNot formalised, and named\
  \ as such: that Kleiman's non-sheaf curve satisfies this\nfile's binders (smooth,\
  \ proper, geometrically integral) is quoted from the\nreference rather than proved.\
  \ Tracked as `AJC.picrep.etale-rep`; the board node\n`AJC.picrep` carries the landed/absent\
  \ split.\n\nThis is the **sole** `sorry` of the seam: everything else below — the\n\
  representing scheme `PicSchemeEt`, its representability, local finiteness,\nseparatedness\
  \ and group-scheme structure, the comparison theorem\n`picEtComparison_isIso_of_hasRationalPoint`\
  \ and the conditional\n`picSchemeOfHasRationalPoint` — is derived from it.\n\n**Why\
  \ the second conjunct is bundled here rather than given its own `sorry`.**\nClause\
  \ (1) is Kleiman §4; clause (2) is Kleiman §2 Thm 2.5 (`th:comp`): given a\nsection,\
  \ the comparison `picSharp C → Pic_{(C/k)ét}` is an isomorphism. Both are\ntheorems\
  \ of the same paper and neither is formalised. They are stated as one\nnamed obligation\
  \ on purpose: the `picSharp`-shaped consumer interface\n(`HasPicScheme`, and through\
  \ it the tangent-space chain and the `k̄` Albanese\nwitness) needs clause (2) to\
  \ exist at all, and splitting it out would report the\nJacobian headline as resting\
  \ on *six* open obligations where the mathematics has\nfive. The bundling adds no\
  \ strength — clause (2) is conditional on a section, so\nit says nothing about a\
  \ pointless curve — and it keeps the frontier count honest\nin both directions.\
  \ `scripts/axiom-frontier.lean` measures the result rather\nthan asserting it."
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.fgaPicardRepresentability
type: lean
updated: '2026-07-29T21:18:38'
---
theorem fgaPicardRepresentability {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    (∃ (X : Over (Spec (.of k))),
        Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
          LocallyOfFiniteType X.hom ∧ IsSeparated X.hom)
      ∧ (HasRationalPoint C → IsIso (PicScheme.picEtComparison C)) :=
  sorry