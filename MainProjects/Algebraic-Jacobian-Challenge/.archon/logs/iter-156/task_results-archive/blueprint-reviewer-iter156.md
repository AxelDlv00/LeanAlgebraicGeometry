# Blueprint Review Report

## Slug
iter156

## Iteration
156

## Top-level summaries

### Incomplete parts
- `Jacobian.tex` / Route A (A.1–A.4 in `thm:nonempty_jacobianWitness` proof + `def:positiveGenusWitness`): **sketch-level, not prover-ready.** Now the critical path for the WHOLE project under the iter-156 route-(b) decision (genus-0 folds into Route A's Pic⁰/Albanese engine; positive-genus needs it regardless), yet A.1–A.4 are high-level mathematical prose with **no `\lean{...}` targets on any sub-step, no lemma/definition blocks, no prover-ready statements.** The smallest entry point (`RelativeSpec` functor, A.1 prerequisite, ~700–1100 LOC) is *named in prose only* (`Jacobian.tex:525`) with no blueprint block behind it. A prover cannot be dispatched on Route A from the current blueprint.

### Proofs lacking detail
- `Jacobian.tex` / `def:positiveGenusWitness`: proof body is "this is the M3 arm … contingent on Route A being prosecuted in full" — a pointer, not a decomposition. Acceptable while Route A is a deferred scaffold, but it is the bottleneck the project just promoted to critical path, so it now needs a real decomposition.

### Multi-route coverage
- **Route A (Pic⁰ / FGA representability engine): PARTIAL → SKETCH.** Covered as the A.1–A.4 decomposition in `Jacobian.tex` and gated-build summary (α) in `def:positiveGenusWitness`, but only at narrative depth. No sub-step is prover-ready. Smallest prover-ready entry point to scaffold: the `RelativeSpec` functor (A.1), which needs its own blueprint block (statement + `\lean{...}` target) before any prover round.
- **Route (b) (dual-AV / Pic⁰(ℙ¹)=0 for genus-0): effectively folded into Route A** per the iter-156 decision, so it needs no *separate* decomposed coverage — BUT the blueprint has not been updated to say so. The genus-0 prose still routes through the differential `df=0` keystone (`thm:rigidity_over_kbar`); see the route-(b) contradiction findings below. The dual-AV argument itself appears only as a 4-line sketch in `Jacobian.tex` C.2.d (line 403) and a one-line mention in `RigidityKbar.tex` (line 25).
- **Route B (symmetric powers / Stein factorisation): correctly documented as historical-not-pursued** in `Jacobian.tex` (B.1–B.3, infrastructure-(β)). No coverage gap — intentionally parked.

### Citation discipline
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: `% SOURCE: Mumford, Abelian Varieties, Ch. II §4` carries **no `(read from references/…)` parenthetical and no `% SOURCE QUOTE:`**. This is normally a hard fail, but here it is *correctly* handled: the block transparently states "verbatim text not yet retrieved — paywalled, no open copy in references/ … recalled text must not be substituted (citation discipline)." This is honest non-fabrication, not a violation. **Soon-severity flag only:** if a prover lane on the keystone ever opens (route a or b), the Mumford source (or a substitute, e.g. the dual-AV argument via Hartshorne/Kleiman) must be retrieved/bundled first.
- `Genus.tex` (informational): the `% NOTE:` comment at lines 8–13 points at `references/hartshorne-ag.md` and `references/stacks-0BUG.md`, **neither of which exists on disk**. These are informal NOTE pointers, not `% SOURCE:` citations, so not a discipline hard-fail — but they are dangling and should be corrected or removed. (The bundled Stacks files present are `stacks-algebra.tex`, `stacks-coherent.tex`, `stacks-fields.tex`, `stacks-varieties.tex`; Hartshorne is not bundled in any form.)

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lean closure is a clean projection from the Albanese witness; sound.
  - Route-(b) staleness (soon): the "Classical description" in the proof of `thm:exists_unique_ofCurve_comp` (line 82) and the §"Implementation route" prose (lines 87–89) still describe the genus-0 case as routing through `thm:rigidity_over_kbar` (the `df=0` rigidity). Under the iter-156 route-(b) decision this should be re-pointed to the Pic⁰/Albanese argument. Not a math error; a prose update to track the new committed route.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter for `Cotangent/GrpObj.lean`; content lives in `RigidityKbar.tex`. Honest disposition of the iter-145 excise; surviving helpers documented as standalone.)

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.
(Project-internal MV/Čech cohomology infrastructure; every block carries a `\lean{...}` target. The theorem RigidityKbar's chart-Čech step consumes, `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`, is present and well-formed.)

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.
(Project-internal $k$-module sheaf cohomology; all blocks have `\lean{...}` targets. No external SOURCE needed.)

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.
(`thm:smooth_locally_free_omega` — the forward Jacobian-criterion target consumed by RigidityKbar piece (i.a) — is well-formed with a verified-Mathlib closure path. Converse direction correctly documented as false with an explicit counterexample. M8 "Serre-duality genus identity" foreshadows exactly the $H^0(C,\Omega_{C/k})=0$ content now on the route-(a) critical path.)

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Informational: dangling file pointers in the `% NOTE:` at lines 8–13 (`references/hartshorne-ag.md`, `references/stacks-0BUG.md` — neither exists). Correct or drop them.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - Route A (now the post-pivot critical path) is **sketch-level**: A.1–A.4 carry no `\lean{...}` targets, no lemma/definition blocks, no prover-ready statements; `def:positiveGenusWitness`'s body is a pointer, not a decomposition. Smallest prover-ready entry point (`RelativeSpec` functor, ~700–1100 LOC) is named in prose only with no block behind it. Needs a dedicated Route A blueprint build-out before any Route A prover round.
  - **Route-(b) contradiction (the directive's focus #2):** the genus-0 framing throughout this chapter still routes genus-0 through the differential `df=0` keystone `thm:rigidity_over_kbar`, NOT the Pic⁰/Albanese argument the iter-156 decision committed to. Concretely: `def:genusZeroWitness` (lines 452–498, `isAlbaneseFor` factorisation reduces to `rigidity_over_kbar` over $\bar k$), the genus-0 sub-case C.2.d (line 395), the Mathlib-infrastructure summary (γ) (line 438, "genus-0 arm gated on `rigidity_over_kbar` + shared cotangent-vanishing pile"), and Layer I (line 539). All of these must be re-pointed to "genus-0 = Alb(genus-0)=0 via Route A's Pic⁰ engine" under route (b). The math is not wrong; the prose contradicts the newly committed route and will mislead a prover/planner reading it as the live path.
  - These two items make the chapter a must-fix blueprint-writer target this/next iter (see Severity).

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.
(Scheme-level rigidity helper `thm:GrpObj_eq_of_eqOnOpen`, formalized and closed; the iter-125 hypothesis-drop refactor is accurately recorded. Downstream-use prose references `rigidity_over_kbar` consistently.)

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Directive focus #1 — CONFIRMED.** The iter-155 `rigidity-regate` re-scope is thorough and honest. `thm:rigidity_over_kbar` is now correctly disclosed as a **gated NAMED GAP** (sorry body, not on a prover lane), in the same family as `thm:nonempty_jacobianWitness`. The false "chart-algebra avoids Serre duality" claims are retracted *throughout*: the chapter introduction (lines 13–26), piece (iv) (line 108), the chart-algebra (β) layer-3 "No-Serre-duality" claim (line 137), the piece-(ii) decomposition scope clarification (lines 1863–1865), and the honest-pile-cost footer (line 2596) all now state that producing `df=0` is an irreducibly global-sections fact, equivalent (given the gap-(i) trivialisation) to $H^0(C,\Omega_{C/k})=0$, hence **on** the critical path under route (a). The chart-algebra envelope is correctly characterized as supplying only the *converse* "$df=0 \Rightarrow$ constant." Math and framing are correct as a disclosed gated gap. **Verdict: complete + correct as required.**
  - The closed/axiom-clean envelope is accurately marked: KDM (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`) closed iter-154 via the self-contained (FT.1)–(FT.3) Mathlib assembly; `constants_integral_over_base_field` collapsed to 3 steps under the alg-closed pivot; the `[IsAlgClosed]+[CharZero]`+`[IsDomain B]` hypotheses are correctly justified by the two recorded counterexamples (CE1 $k\times k$, CE2 $\mathbb Q(\sqrt2)$).
  - Citation discipline on the closed lemmas is strong: KDM and `constants_integral_over_base_field` carry verified Mathlib-name tables; the standard-smooth `% SOURCE QUOTE:` (Stacks 00T7, line 2514) is verbatim from the bundled `references/stacks-algebra.tex`; render-fix NOTEs correct earlier dangling-tag citations honestly.
  - **Route-(b) commitment update needed (soon):** the chapter currently says "the chapter commits to neither" route (a)/(b) (lines 22, 85). The iter-156 route-(b) decision supersedes that. A writer pass should record the commitment and re-frame the route-(a) shared-pile machinery (pieces i–iv, chart-algebra envelope) as the retained off-committed-path record, pointing the live genus-0 keystone at the dual-AV/Pic⁰ argument (which folds into Route A). This does not make the current text mathematically wrong — it honestly says "neither committed" — so it does not flip the focus-#1 verdict; it is a forward-looking re-frame.
  - `\notready` markers (lines 246, 461, 574, 1557, 1650, 1722, 1811, 1828) are correctly placed on the excised/off-path bundled-route design-template blocks; appropriate usage.

## Cross-chapter notes
- The genus-0 `df=0` route is referenced consistently across `Jacobian.tex`, `AbelJacobi.tex`, `Rigidity.tex`, and `RigidityKbar.tex` — which is exactly why the iter-156 route-(b) re-pointing is a *multi-chapter* writer task, not a single-chapter edit. A writer dispatched for the route-(b) reframe should touch `Jacobian.tex` (genus-0 arm, infra-summary γ, Layer I), `AbelJacobi.tex` (classical-description prose), and `RigidityKbar.tex` (commitment paragraph) together to keep the route story consistent.
- `Differentials.tex` M8 (`\dim H^0(C,\Omega_{C/k}) = \dim H^1(C,\mathcal O_C)$, deferred) is the same Serre-duality content `RigidityKbar.tex` gap (ii) needs under route (a). If route (b) is genuinely committed, the route-(a) Serre-duality build (M8 / piece iv, 3000–8000 LOC) drops off the critical path — worth noting in the route-(b) reframe so the project does not double-budget it.

## Severity summary

- **must-fix-this-iter**:
  - `Jacobian.tex` is `complete: partial` AND `correct: partial` → dispatch the blueprint-writing subagent. Two distinct directives can be bundled or split:
    1. **Route A build-out** (the critical-path deliverable): turn A.1–A.4 from sketch into prover-ready blocks, starting with a dedicated block for the `RelativeSpec` functor (A.1 entry point) with a `\lean{...}` target and a precise statement. This is the "eventual Route A scaffolding gate" the directive references.
    2. **Route-(b) re-pointing** of the genus-0 framing (multi-chapter; see Cross-chapter notes) so genus-0 reads as Alb(genus-0)=0 via the Pic⁰/Albanese engine rather than the differential `rigidity_over_kbar`.
- **soon**:
  - `RigidityKbar.tex`: record the iter-156 route-(b) commitment and reframe the route-(a) shared-pile as retained-but-off-committed-path (does not block focus-#1's complete+correct verdict).
  - `RigidityKbar.tex` / `thm:rigidity_over_kbar`: Mumford II§4 source unbundled — retrieve a usable source (or pivot the keystone's citation to the dual-AV argument via bundled Kleiman/Hartshorne) before any keystone prover lane opens.
  - `AbelJacobi.tex`: route-(b) prose update (folded into the multi-chapter reframe above).
- **informational**:
  - `Genus.tex`: dangling NOTE file pointers (`hartshorne-ag.md`, `stacks-0BUG.md` do not exist).

(No prover lane fires this iter per the directive, so the HARD GATE's prover-deferral is moot; these verdicts drive the next blueprint-writer dispatch and the Route A scaffolding gate.)

Overall verdict: `RigidityKbar.tex`'s iter-155 gated-gap re-scope is confirmed complete + correct (focus #1 PASSES), but the iter-156 route-(b) pivot has made `Jacobian.tex`'s Route A coverage (now the project's critical path) a sketch and left its genus-0 framing pointing at the abandoned `df=0` route — both must-fix blueprint-writer targets before any Route A prover round.
