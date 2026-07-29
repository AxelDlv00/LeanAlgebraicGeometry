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
  \ a general field, so an unconditional `RepresentableBy`\nagainst `picSharp` would\
  \ be a FALSE statement, not merely an unproved one. The\nwitness is Kleiman L5105–L5108:\
  \ the real conic `u²+v²+w²=0` in `ℙ²_ℝ`, smooth\nproper geometrically integral with\
  \ no rational point, for which he states\n`Pic_{X/ℝ}` is not representable while\
  \ `Pic_{(X/ℝ)ét}` is. (**Two citations have\nbeen wrong in this slot** — \"§2 L1292–L1302\"\
  , which is about the *absolute*\nfunctor, and then `ex:Pfs`, which compares the\
  \ two *sheafifications*. Neither\nshows `picSharp` failing Zariski descent, and\
  \ `th:cmp` part 1 says it is in fact\nZariski-separated on these binders. Take the\
  \ non-representability directly; see\nthe module docstring.) Against `picEt` it\
  \ is Kleiman's own\ntheorem. `PicScheme.picEt_isSheaf_forget` records the sheaf\
  \ property that makes\nthe difference, and it is proved rather than assumed.\n\n\
  **Expected to stay open, and that is the honest state rather than a defect.**\n\
  The project reaches this statement rather than proving it, and it is the single\n\
  named `sorry` that the whole Jacobian headline rests on. Do not replace it with\n\
  a weaker conditional statement to make a count go down.\n\n**Which route discharges\
  \ it — corrected 2026-07-29 (`review-ajc`), because the\nprevious text named the\
  \ inputs of a route this project does not take.** That\ntext said the inputs are\
  \ `Div` representability \"which needs the Quot scheme\"\n(Kleiman §3 Thm `th:repDiv`)\
  \ together with the Altman–Kleiman quotient lemma\n`smoothProperQuotient`. Both\
  \ belong to the **Grothendieck/Kleiman quotient\nroute**, which is `rejected` on\
  \ the board (`AJC.picrep.quot`,\n`AJC.picrep.serre`) — so a reader who trusted this\
  \ docstring concluded, wrongly,\nthat the seam's own inputs had been abandoned.\n\
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
  \ the\n  instance-free class `AlgebraicJacobian.GaloisDescent.HasGaloisQuotient`\n\
  \  (`FiniteGaloisQuotient.lean`, not imported here), whose\n  only producer is a\
  \ single-field non-vacuity witness\n  (`Picard/GaloisQuotientNonVacuity.lean`).\
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
  \ the correction costs instead, and it is a sharper constraint.**\nRepresentability\
  \ of `picSharp` over an arbitrary field is **FALSE**, so **G3 and\nG4 target a false\
  \ statement as written**, not a hard one. The source says so\ndirectly: Kleiman\
  \ L5105–L5108 on the conic `u²+v²+w²=0` in `ℙ²_ℝ` — smooth,\nproper, geometrically\
  \ integral, no rational point — `Pic_{X/ℝ}` is not\nrepresentable while `Pic_{(X/ℝ)ét}`\
  \ is.\n\n**This does not go through the Zariski-sheaf theorem, and an earlier revision\
  \ of\nthis paragraph wrongly said it did** (`I-0970`). The Lean statement\n`PicScheme.picSharp_isSheaf_zariski_of_representableBy`\
  \ is true and useful, but\nits contrapositive needs \"`picSharp` is not a Zariski\
  \ sheaf\", which no source\nhere establishes — `ex:Pfs` compares the two *sheafifications*,\
  \ and `th:cmp`\npart 1 shows `picSharp ↪ Pic_{(X/S)zar}` on these binders, so it\
  \ is\nZariski-*separated*. The route that does work is\n`not_exists_representing_picSharp_of_not_isIso`\
  \ (see the sheafification paragraph\nabove): comparison-failure alone refutes representability,\
  \ with no topology in\nthe argument. Everything through J5 runs over a separably\
  \ closed\n`k'` where a section is available and the obstruction absent; the break\
  \ is the\ndescent step where the conclusion returns to `k`, and the repair is that\
  \ the\nobject descended must be `picEt` (which has the sheaf property that carries\n\
  descent) rather than `picSharp`. Over `k'` the two agree. Restating G3/G4 that\n\
  way reaches clause (1) with no false intermediate.\n\nNot formalised, and named\
  \ as such: that Kleiman's non-sheaf curve satisfies this\nfile's binders (smooth,\
  \ proper, geometrically integral) is quoted from the\nreference rather than proved.\
  \ Tracked as `AJC.picrep.etale-rep`; the board node\n`AJC.picrep` carries the landed/absent\
  \ split.\n\n**How many inputs the repair has, and which are now in hand** — the\
  \ count has\nmoved twice, so it is stated here as a history rather than as a fact.\n\
  \"Descend `picEt` instead of `picSharp`\" was priced at two inputs (2026-07-29\n\
  `ajc-p1`), then three (`review-ajc`, adding the cross-base identification), and\n\
  is now **four** (`review-ajc`, `I-1135`, adding the section over separably closed\n\
  fields that everything else silently assumes). Present state:\n\n1. **the descent\
  \ test — LANDED.** `Picard/EtaleFieldCover.lean` proves\n   `Spec k' ⟶ Spec k` is\
  \ an étale cover for `k'/k` finite separable and that\n   `picEt` satisfies the\
  \ sheaf axiom at that cover.\n2. **the cross-base identification — CLOSED** (`Picard/PicEtCrossBase.lean`,\n\
  \   `PicScheme.picEt_crossBaseIso`, `sorry`-free and axiom-clean). Without it the\n\
  \   scheme `J5` produces over `k'` would represent `picEt` *of the curve over `k`,\n\
  \   restricted to `k'`-tests* rather than `picEt` of the base-changed curve, and\n\
  \   there would be no functor for the descent datum to be a datum *for* — a\n  \
  \ mismatch no green build would reveal. **Note the hypotheses it does NOT\n   carry**:\
  \ earlier revisions of this paragraph, and the board row, both stated\n   the obligation\
  \ for `k'/k` *finite separable*; the theorem needs neither\n   hypothesis and holds\
  \ for an arbitrary field extension, because the argument is\n   about pullback projections\
  \ rather than about étale covers. Finite-separability\n   is item 1's constraint\
  \ and was double-counted here. Do not budget a\n   separability argument for a cross-base\
  \ step.\n3. **the Galois action and quotient — G1/G2, substantially built, one gate.**\n\
  \   The affine case is proved and the gluing substrate exists; the general\n   existence\
  \ statement is still the instance-free class\n   `AlgebraicJacobian.GaloisDescent.HasGaloisQuotient`.\n\
  \   `AlgebraicJacobian.GaloisDescent.HasStableAffineCover` is **not** a second\n\
  \   gate, but the reason stated here until now was false (`review-ajc`,\n   2026-07-29\
  \ → corrected 2026-07-30 with controls both ways). It said the cover\n   class \"\
  has had a global instance since G2(a) landed\"; that instance,\n   `hasStableAffineCover_of_orbitsInAffineOpen`,\
  \ requires\n   `[ρ.OrbitsInAffineOpen]`, and `inferInstance` for `HasStableAffineCover`\
  \ at an\n   **abstract** semilinear action carrying only `[FiniteDimensional K L]`\n\
  \   `[IsGalois K L]` **fails** with `synthInstanceFailed` (control: with the orbit\n\
  \   hypothesis in scope it succeeds). What is true is that the orbit hypothesis\
  \ is\n   free *at the action this route uses*: `instOrbitsInAffineOpen_pullback`\n\
  \   discharges it for `pullbackSemilinearGalAction` over an arbitrary\n   `Spec\
  \ K`-scheme, so the cover class synthesises there outright — while\n   `HasGaloisQuotient`\
  \ at that same action does **not** (both measured in one\n   probe). That separation\
  \ is what makes G2 one gate rather than two, and it is a\n   sharper statement than\
  \ the absolute it replaces. **Both names are fully\n   qualified on purpose**: they\
  \ live in `Picard/FiniteGaloisQuotient.lean`, which\n   this file does *not* import,\
  \ so a bare `#check HasGaloisQuotient` here fails\n   and would read as absence.\
  \ That is the recorded \"cited names need `#check`,\n   not `grep`\" trap; import\
  \ that module before probing either class.\n4. **a section over separably closed\
  \ `k'` — LANDED 2026-07-30, this item is\n   CLOSED.** This entry read \"NO PRODUCER\
  \ IN THIS PROJECT\" and that is no longer\n   the state: `Curve/SeparablyClosedRationalPoint.lean`\n\
  \   (`hasRationalPoint_of_isSepClosed`, `sorry`-free, axiom-clean) is exactly the\n\
  \   producer it said was absent. What survives, and is the reason the descent step\n\
  \   is still open here, is narrower and was found on that closed item: campaign\
  \ G1\n   consumes the section at a **finite** Galois level, where `IsSepClosed`\
  \ is\n   false, so the `k^s` producer does not reach the step that needs it. That\n\
  \   residue is a filtered-colimit-of-schemes argument tracked as\n   `AJC.picrep.sepclosed-finite`.\
  \ The old absolute is kept visible here because\n   the `[IsAlgClosed]` half of\
  \ it is still true and still the trap: `k^s`, never\n   `k̄`, and `hasRationalPoint_baseChangeField`\
  \ only *propagates* a section that\n   `I-0491` forbids the headline to carry.\n\
  \   This one is upstream of the other three.\n\nMethod note for whoever re-checks\
  \ any absence claim in this area: a bare\n`horizon search picEt` returns ten hits,\
  \ **all from the sibling project**, because\nthe result set is capped — reading\
  \ that as absence in AJC would be a false\nnegative. Query a specific name (`picEtComparison`)\
  \ or scan declaration headers\nin-tree. Two earlier revisions of this paragraph\
  \ offered lists called \"the\ncomplete list\" and **both were wrong** (`I-1075`,\
  \ and a fresh-context audit that\nfound six omissions); neither error touched the\
  \ conclusion, which is why a token\nscan rather than a census is what such a claim\
  \ should rest on.\n\nItem 2 was **not** portable from the sibling project, which\
  \ was the trap, and the\noutcome recorded it: `AJCR` proves a cross-base comparison\
  \ as a `MulEquiv`\n(`picEtCrossBaseEquiv`, `Picard/PicEtCrossBase.lean:316`, 468\
  \ lines), but its\n`picEt` is a hand-built affine-opens limit of plus-classes (`PicEt.lean:105`)\n\
  while this file's is a categorical sheafification (`PicEtSheaf.lean:238`) —\ndifferent\
  \ objects, no `lake` edge. Most of that length is a section-ring scalar\ntower which\
  \ a *sheafification*-based `picEt` does not need, because for it the\nwhole sheafification\
  \ layer collapses to one Mathlib lemma\n(`Functor.pushforwardContinuousSheafificationCompatibility`,\
  \ applicable because\nrestriction along `Over.map` is continuous for the two localised\
  \ étale topologies\nby pure synthesis). Reading the sibling as a design lead rather\
  \ than transcribing\nit was the cheaper move.\n\nThis is the **sole** `sorry` of\
  \ the seam: everything else below — the\nrepresenting scheme `PicSchemeEt`, its\
  \ representability, local finiteness,\nseparatedness and group-scheme structure,\
  \ the comparison theorem\n`picEtComparison_isIso_of_hasRationalPoint` and the conditional\n\
  `picSchemeOfHasRationalPoint` — is derived from it.\n\n**Why the second conjunct\
  \ is bundled here rather than given its own `sorry`.**\nClause (1) is Kleiman §4;\
  \ clause (2) is Kleiman §2 Thm 2.5 (`th:comp`): given a\nsection, the comparison\
  \ `picSharp C → Pic_{(C/k)ét}` is an isomorphism. Both are\ntheorems of the same\
  \ paper and neither is formalised. They are stated as one\nnamed obligation on purpose:\
  \ the `picSharp`-shaped consumer interface\n(`HasPicScheme`, and through it the\
  \ tangent-space chain and the `k̄` Albanese\nwitness) needs clause (2) to exist\
  \ at all, and splitting it out would report the\nJacobian headline as resting on\
  \ *six* open obligations where the mathematics has\nfive. The bundling adds no strength\
  \ — clause (2) is conditional on a section, so\nit says nothing about a pointless\
  \ curve — and it keeps the frontier count honest\nin both directions. `scripts/axiom-frontier.lean`\
  \ measures the result rather\nthan asserting it.\n\n**\"Adds no strength\" is now\
  \ MEASURED, and the measurement is sharper than the\nclaim** (`review-ajc`, 2026-07-30;\
  \ `lake env lean` EXIT=0 in a scratch file,\nsince deleted). Both conjuncts of this\
  \ theorem follow, *together*, from the\nsingle hypothesis\n\n  `∃ X, Nonempty ((PicScheme.picSharp\
  \ C).RepresentableBy X) ∧`\n  `      LocallyOfFiniteType X.hom ∧ IsSeparated X.hom`\n\
  \n— i.e. from the `picSharp`-shaped endpoint that the Milne–Kollár campaign's ten\n\
  modules are built to produce, with **nothing left over**. Clause (1) is\n`hasPicSchemeEt_of_picSharp_representability`\
  \ and clause (2) is\n`isIso_picEtComparison_of_picSharp_representability` (both\n\
  `Picard/PicEtSubcanonical.lean`), the second discarding the section it is handed.\n\
  Axiom-clean `[propext, Classical.choice, Quot.sound]`, against a control — the\n\
  same conclusion *without* the hypothesis, i.e. this theorem — that correctly\nreports\
  \ `sorryAx`. The two halves existed separately; what had not been measured\nis that\
  \ their conjunction is exactly this statement, so no reader had to take\n\"adds\
  \ no strength\" on trust.\n\n**What this does NOT mean, since it is the natural\
  \ misreading.** It does not\nbring the seam closer. The hypothesis is the campaign's\
  \ *undischarged output*,\nand over an arbitrary `k` it is FALSE, not merely unproved:\n\
  `PicScheme.not_exists_representing_picSharp_of_not_isIso`\n(`Picard/PicEtSubcanonical.lean`)\
  \ plus Kleiman's pointless real conic refutes it.\nSo the correct reading is about\
  \ *shape*, not distance: whatever the campaign\ndelivers must be delivered over\
  \ a field where `picSharp` is representable (a\nseparably closed one, or under a\
  \ section), and the descent to `k` must carry\n`picEt` points — and if it does deliver\
  \ that, this bundled statement is fully\ndischarged, with clause (2) costing zero\
  \ extra work."
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.fgaPicardRepresentability
type: lean
updated: '2026-07-30T04:53:11'
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