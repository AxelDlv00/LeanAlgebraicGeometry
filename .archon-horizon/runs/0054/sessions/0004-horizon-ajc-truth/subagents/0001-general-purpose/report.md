## 1. Blueprint: Quot route still presented as the live construction

The chapter that was re-aimed (`Picard_FGAPicRepresentability.tex:20-53`, `:397-411`) is correct. What the previous session missed is the rest of that same chapter, plus the Quot chapter's framing:

- **`blueprint/src/chapters/Picard_FGAPicRepresentability.tex:817-834`** (§"The Picard-scheme existence theorem"). Definitely stale. Present tense: the existence proof "first applies Kleiman §2 Thm 2.5 … and then uses Kleiman's four steps … Hilbert-polynomial stratification, m-regularity bound, Abel-map factorisation, and the smooth-proper quotient. Its inputs are the Quot/Hilbert construction of `chap:Picard_QuotScheme` … and Altman–Kleiman effective descent." This is the route the same chapter declares off-path 780 lines earlier. Minimal edit: one lead sentence — "The derivation recorded here is the quotient route; the committed route is Milne–Kollár (§`sec:fga_pic_setup`)."
- **`Picard_FGAPicRepresentability.tex:732-737`** — the `proof` of `def:inst_has_pic_scheme` (the live gate) is *only* the Quot route: "Apply the FGA representability construction of `thm:fga_pic_representability`. The rational point rigidifies line bundles … and the bounded Hilbert-polynomial strata glue to the required … scheme." Definitely stale: this is the one node a reader consults to learn how the open obligation will be discharged.
- **`Picard_FGAPicRepresentability.tex:875-884`** (§"Assembly of the inputs") — "The FGA construction consumes the relative-divisor functor and Abel map, then applies the regularity, base-change, and effective-quotient results." Same issue, milder.
- **`Picard_QuotScheme.tex:5-12`** (chapter STRATEGY NOTE) and **`:8398-8406`** ("The Picard construction in `chap:Picard_FGAPicRepresentability` applies `thm:quot_representable` … giving the Hilbert scheme … and its open subscheme `Div_{C/k}`"). The chapter must be retained, but these two spots assert the Quot scheme is what the Picard construction consumes. Minimal edit: one clause noting the committed route consumes `Div_{C/k}` (degree slices) and not Quot representability.
- **`Picard_RelPicFunctor.tex:1316-1320`** — "the Grothendieck–Mumford–Kleiman existence theorem **is the next step**". Arguably fine (route-agnostic phrasing), but it is the one forward-pointer left aimed at the quotient route.
- **`RiemannRoch_Adelic.tex:2057`** — uniform H¹ vanishing described as "the curve-level replacement for Castelnuovo–Mumford boundedness **in the Quot endgame**". Wrong consumer: it is cluster-P input to the committed route. One-word-scale fix.
- **Structural miss (biggest one).** `blueprint/src/content.tex:9-42` is a bare `\input` list; `web.tex`/`print.tex` carry no prose. There is no top-level chapter stating the strategy, so the blueprint's *only* representability narrative is the off-path one. The committed route's landed Lean has **zero blueprint coverage** — none of `Picard/RigidPushforward.lean`, `Picard/GaloisDescent/SemilinearModules.lean`, `Picard/FiniteGaloisQuotient{,Affine}.lean`, `Picard/StableAffineCover.lean`, `Picard/RigidifiedPic.lean`, `Picard/SectionRingUniversal.lean`, `Picard/StructureSheafPushforward.lean`, `Picard/DivDegree.lean` appears in any `% archon:covers` line (79 covered files total). Not fixable by a small edit; worth a roadmap node.
- **Stale platform claim, two places.** `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:33-34` ("Mathlib at the pinned revision has no étale Grothendieck topology on schemes") and `Picard_RelPicFunctor.tex:945` ("Mathlib has no etale topology on schemes"). Both false at the pinned rev — `.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Sites/Etale.lean:32-51` defines `etalePrecoverage`/`etalePretopology`/`etaleTopology`. These are the original justification for the rational-point route and directly contradict `TO_USER.md:7-8`, `README.md:47-49` and roadmap `AJC.picrep.rational-point`.

Also note: the caller's premise that `FGAPicRepresentability.lean` can be searched for "OFF-PATH" is wrong — that literal appears nowhere in the Lean tree. The marker is prose at `FGAPicRepresentability.lean:487-492` ("A route … that takes only finite Galois quotients … needs neither this class nor `smoothProperQuotient`").

## 2. `\leanok` attached to sorry-bodied Lean

Honest (no `\leanok`), no action: `thm:pic0_smooth` (`Picard_Pic0AbelianVariety.tex:1095`), `thm:pic0_proper` (`:1211`), and all Jacobian-chapter witness nodes — `def:picardJacobianWitness` (`Jacobian.tex:114`), `lem:curve_hypothesis_gap` (`:156`), `lem:pic0_relative_dimension_genus` (`:185`), `lem:pic0_isAlbanese_all_points` (`:203`), `thm:nonempty_jacobianWitness` (`:227`). The FGA main theorem `thm:fga_pic_representability` (`Picard_FGAPicRepresentability.tex:228`) has statement-`\leanok` but no proof-`\leanok`; its pin `PicScheme.representable` is genuinely sorry-free given `[HasPicScheme C]`, so arguably fine.

Definitely stale — `\leanok` on a **definition whose Lean body is `sorry`** (here `\leanok` claims a construction that does not exist):
- `def:inst_has_pic_scheme`, `Picard_FGAPicRepresentability.tex:723` → `instHasPicScheme := ⟨sorry⟩`, `Picard/FGAPicRepresentability.lean:259-263`
- `def:divisor_degree_pic`, `Picard_IdentityComponent.tex:893` → `PicScheme.degree`, `Picard/IdentityComponent.lean:1427-1432`

Statement-`\leanok` on sorry-bodied theorems (defensible under the "signature is formalized" reading, but each is a claim the reader will misread; none has proof-`\leanok`):
- `thm:pic_zero_dimension_equals_genus`, `Picard_IdentityComponent.tex:1084` → `Pic0Scheme.finrank_eq_genus` sorry, `IdentityComponent.lean:1475`
- `thm:pic_zero_k_points_iff_degree_zero`, `:1135` → `kPoints_iff_kerDegree` sorry, `IdentityComponent.lean:1504`
- `lem:pullback_preserves_finite_limits`, `Cohomology_CechHigherDirectImage.tex:11786` → `pullback_preservesFiniteLimits := sorry`, `Cohomology/CechHigherDirectImageUnconditional.lean:162`. This is one of the two axiom-leaking instances `TO_USER.md:12-18` measures, so the green marker is the most misleading of the set.
- `lem:milne_codim1_indeterminacy`, `Albanese_CodimOneExtension.tex:1657` → sorry, `Albanese/CodimOneExtension.lean:1751`
- `thm:quot_representable`, `Picard_QuotScheme.tex:6507` → `QuotScheme` sorry, `Picard/QuotRepresentability.lean:79`
- `lem:sectionGradedModule_fg`, `Picard_QuotScheme.tex:326` → sorry, `Picard/SerreFiniteness.lean:79`
- `lem:gradedHilbert_fiber`, `Picard_QuotScheme.tex:6412` → sorry, `Picard/SerreFiniteness.lean:262`
- `lem:pullback_tensor_map_isiso`, `Picard_QuotScheme.tex:4062` → sorry, `Picard/QuotFunctorDef.lean:460`
- `lem:gamma_fiber_baseChange_field`, `Picard_QuotScheme.tex:4303` → sorry, `Picard/QuotFunctorDef.lean:715`

`thm:pic0_isAbelianVariety` (`Picard_Pic0AbelianVariety.tex:1405`) and `thm:pic_zero_is_abelian_variety` (`Picard_IdentityComponent.tex:978`) carry `\leanok`; their Lean assemblies are sorry-free term-level (`Pic0AbelianVariety.lean:874`, `:893`) and their `\uses` targets `thm:pic0_smooth`/`proper` are un-`\leanok`'d, so the graph still shows the gap. Arguably fine.

## 3. `informal/pic-representability-campaign.md`

Route of record: internally consistent (header `:4-9`, architecture `:93`, off-path leaf list `:230`).

Rational point: **not** internally consistent. The header asserts "Neither branch is assumed anywhere in this plan" (`:22`), but every milestone is written for branch 1 and several are only executable there: `:55` ("keep `[HasRationalPoint C]` as a hypothesis"), audit item 5 `:279` ("B1 … FALSE without it"), P5's primary route uses `x₀` as the ample divisor (`:87`, `:121`), J4 needs rational points (`:187`), and the declared final state keeps the hypothesis (`:230`). There is no milestone for the étale-sheafification branch at all. Minimal edit: replace `:22` with "every milestone below is written for branch 1; branch 2 replaces B1, P5's `x₀` input and J3–J4 with étale-site work" — that is honest and preserves "the decision is unmade".

Two further defects in the same file:
- Line anchors are systematically drifted (~40-50 lines): `:38` cites `instHasPicScheme` at `FGAPicRepresentability.lean:305-309` (also `:313/:317` at `:453`, `:508`) — actual `:259`, sorry at `:263`; `HasSmoothProperQuotient` `:541`/`smoothProperQuotient` `:561` → actual `:494`/`:514`; `HasRationalPoint` `:139` → `:122`; `picSharp` `:173` → `:150`; `abelMapWitness` `:453` → `:404`; `HasDivFunctor` `:185` → `:168`; `WeilDivisor.lean:1281` → `:1194`; `IdentityComponent.lean:1452` → `:1427`.
- The landings log ends at Part IX, 2026-07-10 (`:543`). It does not record the run-0053 gate factoring (`Picard/RigidPushforwardGate.lean`, four named leaves) or the run-0054 headline wiring, both of which the roadmap carries. A document labelled "route of record" reading two weeks stale on its own critical path.

## 4. AJC roadmap (89 items; only these contradict the stated state)

No item advertises the Quot endgame as the plan — `AJC.picrep`, `AJC.picrep.quot`, `AJC.picrep.serre`, `AJC.picrep.assembly` all carry explicit off-path/retained-not-revived language. Flags:

- **`AJC.jacobian.reachability`** — says the remaining work is "three named leaves in `Jacobian.lean`" and lists `proper`, `smooth` among "four of six witness fields supplied directly by `Picard/Pic0AbelianVariety.lean`", with no note that both are `sorry`-bodied. Contradicts the five-obligation state in `README.md:64-65` and `TO_USER.md:20-27`. Minimal edit: "five obligations — three leaves here plus upstream `Pic0.smooth` and `Pic0.proper`, both `sorry`."
- **`AJC.jacobian.assembly`** (pending) — "Construct `picardJacobianWitness` from Picard representability, the Pic0 abelian-variety structure, dimension g, and the Albanese universal property." Reads as unbuilt; it exists at `AlgebraicJacobian/Jacobian.lean:301`. Minimal edit: state it is assembled and name what is left.
- **`AJC.picrep.rational-point`** — cites `instHasPicScheme` at `Picard/FGAPicRepresentability.lean:316`; actual `:259`. (`AJC.picrep.assembly` has it right at `:259`.)
- **`AJC.picrep.quotbasechange`** (done) — "these are the inputs the Nitsure representability endgame consumes." Arguably fine, but it names only the off-path consumer for modules the committed route also imports; one clause would fix it.
- Untracked: no roadmap node owns the blueprint gap from
