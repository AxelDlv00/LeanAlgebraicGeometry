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
  a weaker conditional statement to make a count go down.\n\n**Which route THIS PROJECT\
  \ takes — and the 2026-07-29 version of this paragraph\noverstated, corrected 2026-07-30\
  \ (`review-ajc`, by reading Kleiman rather than\nthe board).** That version said\
  \ the previous text \"named the inputs of a route\nthis project does not take\"\
  , listing `Div` representability (Kleiman §3 Thm\n`th:repDiv`) and the Altman–Kleiman\
  \ quotient lemma `smoothProperQuotient`, and\nconcluded the prescription was *simply\
  \ wrong* because both belong to the\nGrothendieck/Kleiman quotient route, `rejected`\
  \ on the board\n(`AJC.picrep.quot`, `AJC.picrep.serre`).\n\n**Right about which\
  \ route AJC CHOSE; wrong as a statement about what discharging\nthis `sorry` NEEDS.**\
  \ Read from the source\n(`references/kleiman-picard-src/kleiman-picard.tex`): `th:main`\
  \ L2155–L2166 is\nclause (1)'s **conclusion** verbatim — \"Assume `f : X → S` is\
  \ projective Zariski\nlocally over `S`, and is flat with integral geometric fibers.\
  \ (1) Then\n`Pic_{X/S}` exists, is separated and locally of finite type over `S`,\
  \ and\nrepresents `Pic_{(X/S)ét}`\" — with no rational-point hypothesis. And Kleiman's\n\
  proof reduces (1) to (2) and then runs exactly the two named inputs: the Abel map\n\
  `Div_{X/S} → P` with `Div_{X/S}` an open subscheme of the **Hilbert** scheme by\n\
  `th:repDiv`, descended by `lm:qt`. So the original text was naming the inputs of\n\
  the published proof of this file's own conclusion.\n\n**The projectivity gap identified\
  \ by the fresh-context audit is now closed\n(2026-07-30, `pic-b`).** `th:main`'s\
  \ hypothesis is `f` **projective**\nZariski-locally and flat with integral geometric\
  \ fibres. This file's binders are\n`[SmoothOfRelativeDimension 1 C.hom] [IsProper\
  \ C.hom]\n[GeometricallyIntegral C.hom]` over a field. The rooted theorem\n`Adelic.isProjective_of_smoothProperGeometricallyIntegral`\n\
  (`Picard/CurveProjectivity.lean`) proves exactly the previously missing\nimplication,\
  \ by constructing a finite map to `ℙ¹`, embedding the two pulled-back\nLaurent charts\
  \ into relative projective space, and applying properness to the\nresulting immersion.\
  \ It adds no rational-point or projectivity hypothesis.\nThus projectivity is no\
  \ longer an open antecedent in the comparison with\nKleiman's clause (1); the representability\
  \ construction itself remains the\nobligation described below.\n\nTwo things follow,\
  \ and both matter for planning. `th:repDiv` is **Hilb, not\nQuot** (its statement:\
  \ \"`Div_{X/S}` is representable by an open subscheme of the\nHilbert scheme `Hilb_{X/S}`\"\
  ), so rejecting `AJC.picrep.quot` never rejected it.\nAnd the campaign below is\
  \ **one** route to clause (1); Kleiman's is a second,\nwhose `lm:qt` interface this\
  \ project already pins as `smoothProperQuotient`\n(§4 below — currently `P → P`,\
  \ zero instances) while building its `Div` side\nthrough the Grassmannian instead\
  \ of Hilb. Nobody has priced Hilb-vs-Grassmannian,\nbecause the board filed this\
  \ docstring as stale rather than as an alternative.\nThat is a comparison worth\
  \ making before more work commits to D′; it is *not* a\nrecommendation to switch,\
  \ since Hilb's availability in Mathlib is unmeasured.\nFull detail: `I-1360`.\n\n\
  The committed route is **Milne–Kollár** (`informal/pic-representability-campaign.md`,\n\
  alternative D3), and it needs neither of Kleiman's two:\n\n* `Div^d` representability\
  \ comes through the **Grassmannian**, not Quot:\n  degree slices of `Scheme.DivFunctor`\
  \ (`Picard/DivDegree.lean`, landed), an\n  embedding into `Scheme.Grassmannian`\
  \ of the section module, locally closed\n  carving, and `Grassmannian.representable`\n\
  \  (`Picard/GrassmannianRepresentability.lean`, proved) — campaign milestones\n\
  \  D1′–D4′. D4′ also delivers the locally closed immersion into `Gr` that serves\n\
  \  as the quasi-projectivity certificate.\n* the quotient is the **finite Galois**\
  \ quotient of a semilinear action whose\n  finite orbits lie in affine opens — campaign\
  \ G2, in\n  `Picard/FiniteGaloisQuotient.lean` (`sorry`-free) with Speiser descent\
  \ under\n  `Picard/GaloisDescent/`. It is *not* `smoothProperQuotient`, which is\
  \ false as\n  stated in Lean (see the §4 note below) and must not be built against.\n\
  \  **`sorry`-free is not gate-free here**: the affine case is proved\n  (`isGaloisQuotientSpec`,\
  \ `Picard/FiniteGaloisQuotientAffine.lean`) and the\n  gluing substrate exists,\
  \ but the general existence statement is still the\n  instance-free class `AlgebraicJacobian.GaloisDescent.HasGaloisQuotient`\n\
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
  fields that everything else silently assumes) — **plus a fifth entry added\n2026-07-30\
  \ which is a subtraction, not an input**: all four price the\n`RepresentableBy`\
  \ field of clause (1), and the *other two fields of that same\nclause* are free\
  \ (item 5 below, `I-1286`).\n\n**And a list of inputs is not a route — corrected\
  \ 2026-07-30 (`ajc-p2`), because\nfor four rounds this paragraph was one.** Every\
  \ entry below is an *antecedent*.\nFor four rounds there was **no declaration anywhere\
  \ in this project stating the\ntheorem they are antecedents *of***, and an earlier\
  \ revision of this paragraph —\nwritten by the lane that added `Picard/PicEtDescentAssembly.lean`\
  \ — claimed that\nfile supplied one. **It does not** (refuted by a fresh-context\
  \ audit, `I-1312`,\nreproduced and accepted by its author): none of that file's\
  \ declarations takes a\n`k'`-side representation and concludes over `k`. Its\n`representableByRestrict_of_baseChange`\
  \ concludes a `RepresentableBy` for a\n`k'`-**object**, i.e. it restates the `k'`-side\
  \ input in the right variables rather\nthan crossing the descent step.\n\n**THAT\
  \ GAP IS NOW CLOSED, 2026-07-30 (`pic-e`), and the sentence above is kept in\nthe\
  \ past tense rather than deleted** because the census it rests on is still the\n\
  right way to check this: `Picard/PicEtDescentGoal.lean`'s\n`PicScheme.representableBy_picEt_of_galoisQuotient`\
  \ takes a representation of\n`picEt (C_{k'})` over `k'` plus a Galois quotient of\
  \ its canonical semilinear\naction plus `hcov` plus a named `G1` predicate match\
  \ (`IsInvariantMatch`), and\nconcludes `(picEt C).RepresentableBy Y` over `k`;\n\
  `seamClauseOne_of_isGaloisQuotient` is clause (1) in full through the free side\n\
  conjuncts. `sorry`-free and axiom-clean against this theorem as a `sorryAx`\ncontrol.\
  \ **It closes nothing here**, and what changed is that the goal is now a\nstatement\
  \ a lane can aim an input at, not that any input is in hand.\n\n**AND ONE OF THE\
  \ FOUR IS SINCE GONE — proved free, not supplied** (`pic-e`, same\nday; this sentence\
  \ replaces \"all four of its inputs are explicit undischarged\nhypotheses\", which\
  \ that commit falsified).\n`PicScheme.isInvariantMatch_canonical` (`Picard/PicEtInvariantMatch.lean`)\
  \ proves\nthe `G1` predicate match at the canonical action for every test, with\
  \ **no**\nhypothesis beyond the representation and the curve's own binders — no\
  \ finiteness,\nno separability, no `IsGalois`, no condition on `Gal(k'/k)`. It is\
  \ free because the\ncanonical action's `γ`-component *is* `twistMor γ`, which is\
  \ defined by\ntransporting the functor action along `rep`, so equivariance and invariance\
  \ are two\nreadings of one equation and naturality converts between them. So the\
  \ route from a\n`k'`-side representation to clause (1) field 1 carries **two** named\
  \ antecedents:\nthe Galois quotient at a glued non-affine `X'`, and `hcov`. Consumers\
  \ should call\n`seamClauseOne_of_isGaloisQuotient_noMatch`. **Still nothing here\
  \ is discharged**:\nthe `k'`-side representation is the campaign's undischarged\
  \ output, and clause (1)\nfield 1 is witnessed for no curve.\n\n**ONE CORRECTION\
  \ TO THE COUNT, AND IT IS SMALLER THAN THIS PARAGRAPH FIRST SAID**\n(`pic-e`, 2026-07-30,\
  \ `Picard/PicEtDescentNecessity.lean`; the first revision of this\nbox claimed a\
  \ *third* antecedent \"was never one\", and that claim is **withdrawn** —\n`I-1591`,\
  \ reproduced by its author). The genuine point is only that the paragraph above\n\
  counts the *named* inputs and `seamClauseOne_of_isGaloisQuotient_noMatch` also takes\n\
  `hlft : LocallyOfFiniteType Y.hom`, so a consumer supplies four things, not two.\n\
  \n`hlft` can be *restated* at the `k'` side — but that is a **relocation, not a\n\
  subtraction**, and the reason is structural: `IsGaloisQuotient`'s first field is\
  \ an\nisomorphism `Y_{k'} ≅ X'`, so any property transported along it goes both\
  \ ways, and the\nfour-input form is recoverable from the relocated one in three\
  \ lines. Do not budget\n`hlft` as free. The transferable rule: when a hypothesis\
  \ swap runs through a structure\nthat already contains an iso between the two objects,\
  \ prove the converse before\npublishing a reduction.\n\nWhat *is* clean: the Galois\
  \ binders a first draft of that lemma carried are deletable —\nneither `SemilinearGalAction`\
  \ nor `IsGaloisQuotient` binds `[IsGalois]` or\n`[FiniteDimensional]`, checked at\
  \ the `variable` line, so the word \"Galois\" in both\nnames is about the intended\
  \ application and not about a hypothesis.\n\n**AND `rep` IS NECESSARY, WHICH CHANGES\
  \ WHAT ITS \"0 PRODUCERS\" MEANS.**\n`PicScheme.representableBy_picEt_baseChangeField_of_representableBy`\
  \ derives a\n`k'`-side representation *from* clause (1) field 1 over `k` — the base\
  \ change of the\nrepresenting scheme, for an **arbitrary** field extension, and\
  \ hence\n(`representableBy_picEt_separableClosure_of_representableBy`) at `k^s`,\
  \ where campaign\ncluster `J` lives. So this route is not one sufficient strategy\
  \ that a cheaper `k`-side\nargument might bypass: every solution of clause (1) field\
  \ 1 contains a solution of\n`rep`. The step is generic — an arbitrary adjunction,\
  \ no scheme, no field, no curve\n(`CategoryTheory.Functor.representableByCompLeftAdjoint`)\
  \ — plus `picEt_crossBaseIso`;\ndo not budget a descent argument for it.\n\n**It\
  \ does NOT say the campaign's endpoint is a consequence of the seam, and the first\n\
  revision of this box did say that** (withdrawn, `I-1592`). What follows at `k^s`\
  \ is\nrepresentability of `picEt (C_{k^s})`. Cluster `J`'s stated target is\n`picSharpDeg\
  \ C' r`, a graded `picSharp` which **has no carrier in this project** —\n`#check\
  \ picSharpDeg` returns `unknownIdentifier` — which is the same fact the\n\"eleventh\
  \ item\" paragraph above records from the other side. Identifying the two over\n\
  `k^s` routes through this theorem's own second conjunct, so it is not available\
  \ as an\nargument.\n\n**What that does NOT license, since it is the natural over-reading.**\
  \ It discharges\nnothing: its hypothesis is this very `sorry`. And it is **not**\
  \ a converse of the\ndescent theorem: `hq` at the action these theorems consume\n\
  (`semilinearGalActionOfRepresentableBy C rep`) is untouched by it, including a per-γ\n\
  equality no lemma in the tree closes. So \"the inputs are equivalent to the conclusion\"\
  \nis false. (`isGaloisQuotient_pullbackAction_of_uniqueDescent` was first published\
  \ here\nas the measurement establishing that; it is stated at the *pullback* action\
  \ instead, not\ninterchangeable with the consumed one — `I-1590`, withdrawn as the\
  \ guardrail while\nremaining true of what it does state.)\n\n**Every name in the\
  \ two paragraphs above lives DOWNSTREAM of this file** — in\n`Picard/PicEtDescentNecessity.lean`,\
  \ which imports the seam through\n`Picard/PicEtInvariantMatch.lean`. So a bare `#check`\
  \ for any of them *here* fails with\n`unknownIdentifier` (verified, not assumed),\
  \ and that failure is import direction, not\nabsence. Same trap the `HasGaloisQuotient`/`HasStableAffineCover`\
  \ note in item 3 below\nrecords; import the module before probing.\n\nTwo measurements\
  \ from building it that a consumer needs.\n`quotientHomEquiv_uniform`'s `Nonempty`\
  \ cannot carry the naturality\nsquare a `RepresentableBy` needs, so clause 3 had\
  \ to be re-derived with its\nforward map pinned to a named morphism. And there is\
  \ an asymmetry in what\n`Classical.choice` is spent on: the `RepresentableBy` form\
  \ needs it, while\nclause (1), being an existential, eliminates the quotient's `∃`\
  \ into a `Prop` and\nneeds none — which is why `seamClauseOne_of_isGaloisQuotient`\
  \ is a `theorem` and\nnot a `noncomputable def`. (An earlier revision of this paragraph\
  \ gave a *stronger*\nreason — that the `Prop`-valued `IsGaloisQuotient` \"cannot\
  \ be destructured\" into the\n`Type`-valued conclusion, so the `Nonempty` form was\
  \ forced. That was withdrawn at\n`PicEtDescentGoal.lean` §6 the day it was written:\
  \ `Exists.choose` elaborates\ndirectly, only the `obtain` *tactic* cannot, and the\
  \ same paragraph was already\ninvoking choice. The asymmetry is what survived.)\
  \ The conclusion shape\n`Nonempty ((PicScheme.picEt C).RepresentableBy X)` occurred\
  \ at exactly three sites\n— the `HasPicSchemeEt` class field and the seam `sorry`\
  \ below, plus\n`hasPicSchemeEt_of_picSharp_representability` — and all three are\
  \ **same-field**,\nnone taking a representation over a larger field and concluding\
  \ over `k`\n(measured by `ajc-p2`, re-measured independently by `review-ajc`, `I-1256`).\
  \ With\nthe goal unwritten, an input nobody held would not have shown up as missing.\n\
  \nWhat *is* settled, and it is a pricing fact rather than a step: do **not** budget\n\
  effectivity of `picEt`-**classes** along the field-extension cover. Both halves\
  \ are\nfree from sheafification — `Picard/EtaleFieldCover.lean` already says so\
  \ in prose at\nits own §4 (`:289`, `:294`: \"unique amalgamation\", \"every covering\
  \ sieve, `⊤`\nincluded, free from sheafification\"), and `PicEtDescentAssembly.lean`'s\n\
  `existsUnique_amalgamation_picEt_fieldCover` is that lemma `rfl`-equal, proposition\n\
  and term (`I-1312`). Its `picEt_injective_restrict_baseTest` is the\nsieve-to-single-morphism\
  \ reduction; that step is unavoidable, but it is **not\ngeometric** — the same statement\
  \ closes in an arbitrary category with pullbacks,\nwith every geometric hypothesis\
  \ deleted (`I-1312`, `I-1316`). So what remains is the\n**scheme-level** quotient\
  \ (`G2`, item 3), the covering statement `hcov`, and\n`k'`-side representability\
  \ itself. `I-1280` states the pricing consequence and\n`I-1312` corrects that item's\
  \ overclaims.\n\n**This sentence used to begin with the invariance step** — \"producing\
  \ a compatible\nfamily from a Galois-invariant `k'`-class (`G1`, where the group\
  \ action enters)\" —\nand that item is **gone as of 2026-07-30** (`pic-e`): the\
  \ predicate match `G1` owed\nis free at the canonical action (`PicScheme.isInvariantMatch_canonical`,\n\
  `Picard/PicEtInvariantMatch.lean`), for an arbitrary extension, so the group action\n\
  does not enter as an obligation here at all. The clause is removed rather than\n\
  struck because it was a list of what remains, and it no longer does.\n\n**AND THE\
  \ SENTENCE THREE PARAGRAPHS UP IS NOW STALE TOO, in the same cheap\ndirection**\
  \ (`pic-e`, 2026-07-31). It says what remains is \"the **scheme-level**\nquotient\
  \ (`G2`, item 3), the covering statement `hcov`, and `k'`-side\nrepresentability\
  \ itself\". Of those three, `hcov` is **closed**\n(`coverSelfSection_generate_mem_etaleTopology`,\
  \ `pic-f`), and the scheme-level\nquotient is discharged from the orbit hypothesis\
  \ alone — see the withdrawal in\nitem 3 below. So at the spelling\n`PicScheme.seamClauseOne_of_hasGaloisQuotient_lftFree`\n\
  (`Picard/PicEtGaloisQuotient.lean`) the descent step's remaining *instance* binder\n\
  is **one**: `OrbitsInAffineOpen`. The list is left standing rather than rewritten\n\
  because each entry is corrected at its own item; what a costing should read\ninstead\
  \ is the reduction below.\n\n**THE WHOLE OF THIS SEAM NOW HAS A NAMED SUFFICIENT\
  \ CONDITION, and it is the\nclassical pointed theorem** (`pic-e`, 2026-07-31,\n\
  `Picard/PicEtPointedReduction.lean`, 11 declarations, `sorry`-free, all\naxiom-clean\
  \ against this theorem as a control).\n`fgaPicardRepresentability_of_pointedPicSharpRep`\
  \ derives **both** conjuncts\nbelow, verbatim, over an **arbitrary** `k`, from `Scheme.PointedPicSharpRep`:\n\
  `picSharp`-representability for curves that *have* a rational point, uniform in\n\
  the base field, plus `FiniteInAffine` of the representing scheme. So the\narbitrary-field\
  \ difficulty that `I-0491` deliberately put on this statement — the\nthing that\
  \ makes it harder than FGA/Kleiman as classically proved — is\n**discharged**, and\
  \ a lane proving that antecedent closes this `sorry` by `exact`.\nThe rational point\
  \ is *produced*, not assumed\n(`exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral`\
  \ is\nunconditional at these very binders), so nothing here carries `[HasRationalPoint\
  \ C]`\nand `I-0491` is respected. Price against the weaker\n`seamClauseOne_of_hasGoodGaloisLevel`:\
  \ it needs **one** finite Galois level, has no\nrational point in its statement,\
  \ and does not bind `[GeometricallyIntegral]`.\n**Two cautions from that file, both\
  \ measured there**: `PointedPicSharpRep` is\nderivable *from this very `sorry`*\
  \ up to `FiniteInAffine`, so axiom-check any\nclaimed proof rather than trusting\
  \ a green build; and no curve is exhibited\nsatisfying `FiniteInAffine` at its Picard\
  \ scheme.\n\nPresent state of the four:\n\n1. **the descent test — LANDED.** `Picard/EtaleFieldCover.lean`\
  \ proves\n   `Spec k' ⟶ Spec k` is an étale cover for `k'/k` finite separable and\
  \ that\n   `picEt` satisfies the sheaf axiom at that cover.\n2. **the cross-base\
  \ identification — CLOSED** (`Picard/PicEtCrossBase.lean`,\n   `PicScheme.picEt_crossBaseIso`,\
  \ `sorry`-free and axiom-clean). Without it the\n   scheme `J5` produces over `k'`\
  \ would represent `picEt` *of the curve over `k`,\n   restricted to `k'`-tests*\
  \ rather than `picEt` of the base-changed curve, and\n   there would be no functor\
  \ for the descent datum to be a datum *for* — a\n   mismatch no green build would\
  \ reveal. **Note the hypotheses it does NOT\n   carry**: earlier revisions of this\
  \ paragraph, and the board row, both stated\n   the obligation for `k'/k` *finite\
  \ separable*; the theorem needs neither\n   hypothesis and holds for an arbitrary\
  \ field extension, because the argument is\n   about pullback projections rather\
  \ than about étale covers. Finite-separability\n   is item 1's constraint and was\
  \ double-counted here. Do not budget a\n   separability argument for a cross-base\
  \ step.\n3. **the Galois action and quotient — G1/G2, substantially built; the gate\
  \ now\n   bites only off the affine locus.** Updated 2026-07-30 (`ajc-p1`): the\
  \ class\n   `AlgebraicJacobian.GaloisDescent.HasGaloisQuotient` is **no longer\n\
  \   instance-free**. `hasGaloisQuotient_of_isAffine`\n   (`Picard/GaloisQuotientAffineGeneral.lean`,\
  \ global `instance`, `sorry`-free and\n   axiom-clean against a control that still\
  \ reports `sorryAx` on this very\n   theorem) discharges it for **every** semilinear\
  \ action on an affine total\n   space — not just for the affine *model* `specSemilinearGalAction`,\
  \ which is\n   what `isGaloisQuotient_spec` had covered. The step was\n   `isGaloisQuotient_congr`,\
  \ transport of `IsGaloisQuotient` along an equivariant\n   isomorphism over `Spec\
  \ L`, applied to `X.isoSpec`; it subsumes the former\n   single-object witness `hasGaloisQuotient_specF4`\
  \ by `inferInstance`.\n   **THE PARAGRAPH THAT STOOD HERE IS WITHDRAWN — IT WAS\
  \ FALSE, AND FALSE IN THE\n   EXPENSIVE DIRECTION** (`pic-e`, 2026-07-31, measured\
  \ with controls both ways;\n   reproduced from a fresh-context audit before editing).\
  \ It said: \"the campaign\n   consumer `J'_r` is a *glued* scheme, hence non-affine,\
  \ and `inferInstance` for\n   the gate at an abstract action carrying the orbit\
  \ hypothesis but not affineness\n   **fails** (measured, control both ways). So\
  \ the remaining `G2(c)` work is\n   exactly the `Scheme.GlueData` assembly of the\
  \ per-chart quotients.\"\n   `inferInstance` **SUCCEEDS** at exactly that shape\
  \ — an abstract `ρ` with\n   `[FiniteDimensional K L] [IsGalois K L] [ρ.OrbitsInAffineOpen]`\
  \ and no\n   affineness — and fails only without the orbit binder. The producer\
  \ is\n   `hasGaloisQuotient_of_orbitsInAffineOpen`\n   (`Picard/GaloisDescent/GaloisQuotientOverlap.lean`),\
  \ a **global** instance\n   built from `isGaloisQuotient_glued`, i.e. the `Scheme.GlueData`\
  \ assembly that\n   this paragraph called the remaining work **is already done**.\
  \ Both stale\n   sentences told a lane to budget work that exists, which is worse\
  \ than an\n   optimistic error because nobody re-tests a prohibition.\n   **What\
  \ survives**: the gate's price is the *orbit* hypothesis, and that is a\n   real\
  \ one — `[ρ.OrbitsInAffineOpen]` at the Picard scheme is unproved here, and\n  \
  \ it is where quasi-projectivity and the Hironaka trap actually enter.\n   `Picard/PicEtPointedReduction.lean`\
  \ carries it as the scheme-level\n   `FiniteInAffine` (`orbitsInAffineOpen_of_finiteInAffine`)\
  \ and shows it is\n   neither free nor vacuous. So still do not read \"the gate\
  \ has an instance\" as\n   \"input 3 is closed\" — but the reason is the orbit hypothesis,\
  \ not gluing.\n   `AlgebraicJacobian.GaloisDescent.HasStableAffineCover` is **not**\
  \ a second\n   gate, but the reason stated here until now was false (`review-ajc`,\n\
  \   2026-07-29 → corrected 2026-07-30 with controls both ways). It said the cover\n\
  \   class \"has had a global instance since G2(a) landed\"; that instance,\n   `hasStableAffineCover_of_orbitsInAffineOpen`,\
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
  \ `k'` — LANDED 2026-07-30, this item is\n   CLOSED.** (Read item 5 below first\
  \ if you are pricing the descent: the\n   four-input list prices clause (1)'s *first*\
  \ field only.) This entry read \"NO\n   PRODUCER IN THIS PROJECT\" and that is no\
  \ longer\n   the state: `Curve/SeparablyClosedRationalPoint.lean`\n   (`hasRationalPoint_of_isSepClosed`,\
  \ `sorry`-free, axiom-clean) is exactly the\n   producer it said was absent. What\
  \ survives, and is the reason the descent step\n   is still open here, is narrower\
  \ and was found on that closed item: campaign G1\n   consumes the section at a **finite**\
  \ Galois level, where `IsSepClosed` is\n   false, so the `k^s` producer does not\
  \ reach the step that needs it. That\n   residue is a filtered-colimit-of-schemes\
  \ argument tracked as\n   `AJC.picrep.sepclosed-finite`. The old absolute is kept\
  \ visible here because\n   the `[IsAlgClosed]` half of it is still true and still\
  \ the trap: `k^s`, never\n   `k̄`, and `hasRationalPoint_baseChangeField` only *propagates*\
  \ a section that\n   `I-0491` forbids the headline to carry.\n   This one is upstream\
  \ of the other three.\n5. **THE TWO SIDE CONJUNCTS OF CLAUSE (1) ARE FREE, AND BOTH\
  \ ARE NOW\n   DISCHARGED IN-TREE** — found 2026-07-30 (`review-ajc`, `I-1286`) because\
  \ items\n   1–4 above priced the *first* field of clause (1); landed the same day\n\
  \   (`ajc-p1`, `Picard/PicEtSeparated.lean`, roadmap\n   `AJC.picrep.etale-rep.separated`).\
  \ Clause (1) is a three-field existential, and\n   no roadmap row under `AJC.picrep.etale-rep`\
  \ mentions either side conjunct.\n   **The stronger claim first published here —\
  \ that they were \"never mentioned\"\n   anywhere — is FALSE and is withdrawn**\
  \ (`review-ajc`, corrected by a\n   fresh-context audit): they were priced a day\
  \ earlier, as *free by transport\n   from the `picSharp` endpoint*, on the board\
  \ row `AJC.picrep` (\"SAME scheme, so\n   `LocallyOfFiniteType` and `IsSeparated`\
  \ ride along unchanged\") and in\n   `Picard/PicEtSubcanonical.lean`, in the docstring\
  \ of\n   `hasPicSchemeEt_of_picSharp_representability` (\"the local-finiteness and\n\
  \   separatedness conjuncts are carried across unchanged, because the transport\n\
  \   does not move the representing scheme\"). What is genuinely new here is a\n\
  \   *different* route — free from a bare `picEt` representation, with no `picSharp`\n\
  \   detour — and the descent-unavailability fact below. That distinction is\n  \
  \ load-bearing: on the **field-descent** route this board actually holds, the\n\
  \   transport argument is not available, so there the two conjuncts really were\n\
  \   live and unpriced. So **clause (1) is now a two-field obligation**, and a\n\
  \   lane closing the descent step should target\n   `seamClauseOne_of_representableBy_locallyOfFiniteType`.\
  \ Measured, `lake env\n   lean` EXIT=0, axiom-clean against a control that fires\
  \ `sorryAx` here:\n   * `LocallyOfFiniteType` **descends** across the cover. At\
  \ `k'/k` with\n     `[Module.Finite k k']` `[Algebra.IsSeparable k k']`,\n     `Spec.map\
  \ (algebraMap k k')` is `Surjective`, `Flat` and `QuasiCompact` all\n     by `inferInstance`,\
  \ and Mathlib's\n     `DescendsAlong @LocallyOfFiniteType (@Surjective ⊓ @Flat ⊓\
  \ @QuasiCompact)`\n     (`Morphisms/LocalFlatDescent.lean`) then closes it via\n\
  \     `of_pullback_fst_of_descendsAlong`.\n   * `IsSeparated` **cannot** descend\
  \ with Mathlib `v4.31` — and does not need\n     to. There is no `DescendsAlong\
  \ @IsSeparated` instance, and the diagonal\n     route through `IsSeparated.isSeparated_eq_diagonal_isClosedImmersion`\
  \ fails\n     too, because `DescendsAlong @IsClosedImmersion` is *also* absent\n\
  \     (`IsClosedImmersion` is not a `HasRingHomProperty`, so\n     `HasRingHomProperty.descendsAlong_flat`\
  \ does not apply).\n     **So do not budget a separatedness-descent argument: the\
  \ lemma it would cite\n     does not exist.** (A previous revision of this sentence\
  \ added \"Mathlib has\n     exactly five such scheme instances\", listing the five\
  \ in\n     `Morphisms/LocalFlatDescent.lean`. **That count was FALSE and is withdrawn**\n\
  \     — `review-ajc`, corrected by a fresh-context audit, `I-1315`.\n     `Morphisms/FlatDescent.lean`\
  \ registers six more, all of which synthesise on\n     probe: `Surjective`, `UniversallyClosed`,\
  \ `UniversallyOpen`,\n     `UniversallyInjective`, `isomorphisms Scheme`, `IsOpenImmersion`\
  \ — eleven,\n     not five. It was one file's count published as Mathlib's, three\
  \ lines below\n     this file's own method note warning about exactly that. The\
  \ absence of the\n     two properties above is unaffected: it was measured by failed\
  \ synthesis, not\n     inferred from any list. Do not quote a total here; grep\n\
  \     `DescendsAlong` and count.) Separatedness instead comes from the *group structure\
  \ of\n     the represented object*: `picEt` is `CommGrpCat`-valued (`picEtCommGrp`),\
  \ so\n     ANY scheme representing it is a group object over `Spec k` by Yoneda\n\
  \     transport (`CommGrpObj.ofRepresentableBy _ (picEtCommGrp C)\n     (rep.ofIso\
  \ (picEtCommGrpForgetIso C))`), and a group scheme over a field is\n     separated.\
  \ From a bare `(PicScheme.picEt C).RepresentableBy X` this is a\n     theorem —\
  \ it does not even use `[GeometricallyIntegral C.hom]`.\n   **BOTH ARE NOW LANDED,\
  \ 2026-07-30 (`ajc-p1`), in\n   `Picard/PicEtSeparated.lean`** — so this item is\
  \ no longer a costing, and the\n   sentence that stood here (\"the one brick is\
  \ a **port** … none of those three\n   names exists in this project\") is false\
  \ at HEAD and replaced. Mathlib still\n   does not have \"group scheme over a field\
  \ is separated\" (re-measured both ways\n   in one probe: `IsClosedImmersion η[G].left`\
  \ synthesises for `[GrpObj G]` over\n   `Spec K` while `IsSeparated G.hom` does\
  \ **not**), and the argument is\n   transcribed from `Algebraic-Jacobian-Challenge-Rebuild`'s\n\
  \   `AbelianVariety/GroupSeparated.lean`; all three names now exist here.\n   *\
  \ field 3: `isSeparated_of_representableBy_picEt` — `IsSeparated X.hom` from a\n\
  \     bare `(PicScheme.picEt C).RepresentableBy X`, arbitrary field, and\n     `seamClauseOne_of_representableBy_locallyOfFiniteType`\
  \ restates clause (1) as\n     the **two-field** obligation. Aim a descent step\
  \ at *that*.\n   * field 2: `locallyOfFiniteType_of_baseChange` — the descent above,\
  \ carried\n     out, so the contrast is compiler-checked rather than asserted. **The\
  \ two side\n     conjuncts are free for opposite reasons**, which is the part a\
  \ costing gets\n     wrong: one is a descent argument and the other is free precisely\
  \ because\n     descent is unavailable for it. Field 2 descends at an **arbitrary**\
  \ field\n     extension: its theorem formerly carried `[Algebra.IsSeparable k k']`\
  \ and\n     `[Module.Finite k k']` and consumed neither, and both are now deleted\n\
  \     (`I-1356`). Finite separability is **input 1's** price —\n     `picEt_ext_of_pullback_agrees`\
  \ genuinely needs it — so this is the *same*\n     double-count the input-2 note\
  \ below corrects, and it was live in two files.\n   Both `sorry`-free and axiom-clean\
  \ against this theorem as a control; gate-free\n   (no `HasPicSchemeEt` binder on\
  \ any of them, checked by full signature per\n   `I-1292`, not by header). Non-vacuity\
  \ measured: dropping `rep` leaves\n   `IsSeparated X.hom` for an arbitrary `X` and\
  \ `infer_instance` **fails**.\n   **This is not a discount on the seam**: `k'`-side\
  \ representability is still\n   the campaign's undischarged output, and field 1\
  \ is witnessed for no curve. It\n   removes two obligations nobody had counted,\
  \ and forecloses one dead end.\n\nMethod note for whoever re-checks any absence\
  \ claim in this area: a bare\n`horizon search picEt` returns ten hits, **all from\
  \ the sibling project**, because\nthe result set is capped — reading that as absence\
  \ in AJC would be a false\nnegative. Query a specific name (`picEtComparison`) or\
  \ scan declaration headers\nin-tree. Two earlier revisions of this paragraph offered\
  \ lists called \"the\ncomplete list\" and **both were wrong** (`I-1075`, and a fresh-context\
  \ audit that\nfound six omissions); neither error touched the conclusion, which\
  \ is why a token\nscan rather than a census is what such a claim should rest on.\n\
  \nItem 2 was **not** portable from the sibling project, which was the trap, and\
  \ the\noutcome recorded it: `AJCR` proves a cross-base comparison as a `MulEquiv`\n\
  (`picEtCrossBaseEquiv`, `Picard/PicEtCrossBase.lean:316`, 468 lines), but its\n\
  `picEt` is a hand-built affine-opens limit of plus-classes (`PicEt.lean:105`)\n\
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
  Axiom-clean `[propext, Classical.choice, Quot.sound]`. The two halves existed\n\
  separately; what had not been measured is that their conjunction is exactly this\n\
  statement, so no reader had to take \"adds no strength\" on trust.\n\n**The control\
  \ here has a trap in it, and the trap is worth more than the\nresult.** The obvious\
  \ control — \"does the conclusion close *without* the campaign\nhypothesis?\" —\
  \ **succeeds**, so read naively it says the reduction is empty.\n`exact?` closes\
  \ clause (1) hypothesis-free via\n`HasPicSchemeEt.has_pic_scheme_et`, and clause\
  \ (2) via\n`picEtComparison_isIso_of_hasRationalPoint`. Both are legitimate terms;\
  \ both\nroute through `instHasPicSchemeEt`, which *is* a projection of the `sorry`\
  \ below.\nMeasured: the hypothesis-free version reports\n`[propext, sorryAx, Classical.choice,\
  \ Quot.sound]` while the version above\nreports no `sorryAx`. So on this seam **provability\
  \ is not a discriminating\ncontrol and the axiom list is** — because an unconditional\
  \ gate instance makes\nevery statement in its domain provable. Anyone probing a\
  \ reduction anywhere near\n`HasPicSchemeEt` should compare axiom lists, not success\
  \ and failure.\n\n**What this does NOT mean, since it is the natural misreading.**\
  \ It does not\nbring the seam closer. The hypothesis is the campaign's *undischarged\
  \ output*,\nand over an arbitrary `k` there is a refutation waiting for it —\n`PicScheme.not_exists_representing_picSharp_of_not_isIso`\n\
  (`Picard/PicEtSubcanonical.lean`) turns any failure of\n`IsIso (picEtComparison\
  \ C)` into a refutation of the existential, and Kleiman's\npointless real conic\
  \ is where that failure is expected.\n\n**Stated precisely, because the first version\
  \ of this paragraph overstated it**\n(`review-ajc`, corrected within the same session):\
  \ that refutation is\n*conditional* on `¬ IsIso (picEtComparison C)`, which is **quoted\
  \ from Kleiman,\nnot proved in this project** — `PicEtSubcanonical.lean` says so\
  \ itself, and\nformalising it means exhibiting `φ*O(1)` in `picEt C (Spec ℝ)` outside\
  \ the image\nvia `h⁰` on `ℙ¹_ℂ`. So the honest word for the campaign's `picSharp`\
  \ endpoint\nover arbitrary `k` is **unproved with a refutation route mapped out**,\
  \ not\n\"FALSE\" — the reduction above is a theorem, its trigger is not. Writing\
  \ \"FALSE\"\nhere would be the same error the board row was corrected for in the\
  \ opposite\ndirection.\n\nEither way the consequence for planning is unchanged:\
  \ whatever the campaign\ndelivers must be delivered over a field where `picSharp`\
  \ is representable (a\nseparably closed one, or under a section), and the descent\
  \ to `k` must carry\n`picEt` points — and if it does deliver that, this bundled\
  \ statement is fully\ndischarged, with clause (2) costing zero extra work."
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.fgaPicardRepresentability
type: lean
updated: '2026-07-31T11:58:56'
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