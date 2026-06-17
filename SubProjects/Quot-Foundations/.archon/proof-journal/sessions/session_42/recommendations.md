# Recommendations — after iter-042 (for the iter-043 plan agent)

## 0. Closest-to-completion: gap2 `isLocalizedModule_basicOpen` (QuotScheme.lean) — 80% done
The hard core is in hand: `section_localization_hfr_aux_general` (gap2-core transport) +
`fromSpec_image_top_section_coherence` (the crux coherence the blueprint flagged as the sole genuinely new
piece) are both proven axiom-clean. gap2 itself is on the leandag frontier. Two precisely-scoped pieces
remain — **build Piece A first, then Piece B is a direct bridge-(I) assembly.**

- **Piece A — QC preserved under pullback along `hU.fromSpec` (NEW Mathlib-absent gap, ~moderate).** Need
  `((pullback hU.fromSpec).obj M).IsQuasicoherent` for `[M.IsQuasicoherent]` (then gap1
  `isIso_fromTildeΓ_of_isQuasicoherent` supplies `hP1` directly, since the pullback lives on `Spec Γ(X,U)`).
  Mathlib has no such instance (only `tilde` is QC). Route: `(pullback hU.fromSpec).obj M =
  (pullback isoSpec.inv).obj ((pullback U.ι).obj M)`; reduce to "restriction of QC along an open immersion is
  QC" by building `QuasicoherentData` for `(pullback U.ι).obj M` from `M`'s data `q`, intersecting the cover
  with `U` (`{U ⊓ q.X i}`) and pulling slice presentations back (`SheafOfModules.Presentation.map` +
  `pullbackObjFreeIso`). **This is a distinct sub-build (QC machinery), not section-localization** — consider
  a dag-walker / effort-breaker on it before the prover if the cone looks under-declared.
- **Piece B — eqToHom bridge to `restrictBasicOpenₗ` (mechanical, ~60–100 LOC).** From
  `section_localization_hfr_aux_general M hU.fromSpec hP1 F f rfl` to
  `IsLocalizedModule (powers f) (restrictBasicOpenₗ M f)` via `isLocalizedModule_of_ringEquiv_semilinear`
  with `ρ := (X.presheaf.mapIso (eqToHom eT.symm).op).commRingCatIsoToRingEquiv`. Its only non-trivial input
  is `ρ F = f`, **already discharged by the proven crux `fromSpec_image_top_section_coherence`**. See the
  task_result Piece-B bullet for the exact `e₁/e₂/he₁/he₂/hh` shapes.

## 1. BLUEPRINT must-fix before the iter-043 gap2 prover (lean-vs-blueprint-checker major)
Dispatch a blueprint-writer on `Picard_QuotScheme.tex`, block `lem:qcoh_section_localization_basicOpen`,
to fix two sketch defects that would mislead the iter-043 prover:
1. **Name the eqToHom-bridge crux.** The sketch never mentions `fromSpec_image_top_section_coherence` (the
   `ρ(σ f) = f` coherence); a prover would have to rediscover this obstacle. Add it as a named sub-step.
2. **Drop "the sole new piece" framing.** `section_localization_hfr_aux_general` already exists as a proved
   helper that reduces gap2 to an instantiation; the prose still describes the transport as to-be-supplied →
   duplication risk. Re-point the sketch at "instantiate the existing core at `j = hU.fromSpec` + supply
   Piece A (QC-pullback) + Piece B (eqToHom bridge)."
Report: `.archon/task_results/lean-vs-blueprint-checker-quot-iter042.md`.

## 2. Dedup decision: G1-core vs descent (lean-auditor major) — planner call
`isLocalizedModule_basicOpen_of_isQuasicoherent` (2433) and `isLocalizedModule_basicOpen_descent` (2396) have
**identical signatures**. The descent goes via the cover; G1-core goes via
`isIso_fromTildeΓ_of_isQuasicoherent` (which is built *from* the descent), so G1-core is a longer route to the
same fact. Both are public. Recommended resolution: keep `isLocalizedModule_basicOpen_of_isQuasicoherent` as
the blueprint-named public face (`lem:qcoh_affine_section_localization`) and either make
`isLocalizedModule_basicOpen_descent` `private`/`local`, or restate G1-core as a one-line alias of the
descent (it currently re-routes through gap1 unnecessarily). Not a soundness issue — a naming/cleanliness
call; flag to a refactor subagent if the planner wants it actioned. Report:
`.archon/task_results/lean-auditor-quot-iter042.md`.

## 3. Coverage debt — 4 new `lean_aux` helpers need blueprint blocks (`unmatched=4`)
All proved, no blueprint entry. The review agent does not author prose; planner should add blocks (likely as
`\uses`-children of `lem:qcoh_section_localization_basicOpen`):
- `Scheme.Modules.restrictₗ` — `Γ(X,U)`-linear section restriction (compHom-target). Deps: `Scheme.Modules.map_smul`.
- `Scheme.Modules.restrictBasicOpenₗ` — `Γ(X,U)`-linear basic-open restriction (scalar-tower). Deps:
  `Scheme.Modules.map_smul`, `algebraMap_smul`, and the `algebraMap = X.presheaf.map` defeq.
- `Scheme.Modules.fromSpec_image_top_section_coherence` — the gap2 `fromSpec`-section coherence crux. Deps:
  `IsAffineOpen.fromSpec_app_self`, `Scheme.Hom.appIso_hom'`/`appLE`, `fromSpec_preimage_self`, presheaf `Subsingleton`.
- `Scheme.Modules.section_localization_hfr_aux_general` — gap2-core transport. Deps: `gammaPullbackImageIso`
  (+`_hom_semilinear`/`_hom_naturality`), `gammaImageRingEquiv`, `isLocalizedModule_restrict_of_isIso_fromTildeΓ`,
  `isLocalizedModule_of_ringEquiv_semilinear`, `Submonoid.map_powers`.

## 4. FBC — iter-043 MUST dispatch the prover (affine tilde-transport)
Per the iter-042 plan's HARD constraint (progress-critic: a 2nd consecutive no-prover FBC iter =
CHURNING-by-avoidance): iter-043 dispatches the FBC prover on the blueprinted affine tilde-transport route
(`lem:pushforward_base_change_mate_sections_direct`, ~150–350 LOC, frontier, effort 5351). The conjugate
`gstar_transpose` route is exhausted in-loop (5 iters 037–041) and closed — do NOT reopen it. Cheapest
reversal signal (already armed): if the direct `Γ(α)` computation cannot avoid re-deriving the section mate,
the bypass was illusory → escalate via `USER_HINTS.md`.

## 5. Minor cleanups (lean-auditor, non-blocking)
- Stale comment at QuotScheme.lean:650 ("not yet formalized") — G1-core now exists at 2433.
- The 4 gap2 forward helpers + G1-core are currently unconsumed in-project; they get consumers once gap2
  (Piece A+B) lands and GF-G1 imports QuotScheme.lean (iter-043 import + GF-G1 per the iter-042 plan).

## Do-NOT-retry / discipline notes
- gap2 `isLocalizedModule_basicOpen` was NOT stubbed with `sorry` — correct mathlib-build discipline. Do not
  re-dispatch a bare "assemble gap2" round: send the prover at **Piece A first** (a distinct QC-pullback
  build), THEN Piece B. The crux + core transport are done; re-attempting them is wasted work.
- FBC conjugate route: do not reopen (exhausted 5 iters, kill-criterion fired iter-039, pivot executed
  iter-042).
