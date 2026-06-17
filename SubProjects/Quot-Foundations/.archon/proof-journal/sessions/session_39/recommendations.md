# Recommendations for iter-040 plan

## 0. FBC — KILL-CRITERION FIRED: do NOT run another conjugate reframing round (HIGH / must-fix)

The iter-039 plan armed an explicit kill-criterion on the FBC `_legs_conj` lane:

> *"if conj-2b/2d land axiom-clean but the reframing does NOT close `_legs_conj` this iter, the
> reframing is the genuine wall → iter-040 does NOT run another conjugate round; escalate via
> TO_USER.md and open the fallback."*

**This criterion has now FIRED.** conj-2b (`base_change_mate_reindex_conj_pullbackLeg`) and conj-2d
(`base_change_mate_reindex_conj_crossLayer`) landed axiom-clean; the single-`conjugateEquiv`-component
reframing did NOT close `_legs_conj` (sorry @1822). All three legs (conj-2b/2c/2d) are now in hand, so
the residual is a **pure reframing obstruction with no missing ingredient** — and it has resisted three
consecutive iters (iter-037 assembly tripwire, iter-038 analogist KEEP, iter-039 prover kill-criterion).

**Action for iter-040 — pivot to the fallback, NOT another conjugate round:**
- **Option A (planner's primary fallback):** reopen the element-`ext` / explicit-inverse route, now
  using the BUILT conj-2b/2c/2d as the change-of-rings dictionary (the missing dictionary was the
  reason iter-035's element-`ext` produced no normal form — it is now supplied). This is a genuine
  change of strategy, not a re-run.
- **Option B:** dispatch the **refactor** subagent to rebuild the `_legs` comparison directly from
  `leftAdjointCompIso` primitives (the analogist's "contained-cascade" shape), inserting `sorry` at the
  one reframing site rather than threading it through `conjugateEquiv.injective`.
- Do NOT re-assign a conjugate-component/assembly prover round on `_legs_conj`. The blueprint NOTE
  (updated this review) records the fired criterion. Recommend an **api-alignment mathlib-analogist**
  consult on "section composite ↔ single conjugateEquiv value" typing BEFORE committing to A vs B —
  the obstruction is which adjunction to pin, a design question.
- A2 (`affineBaseChange_pushforward_iso` affine-reduction sorries @2470/2492) stays gated behind the
  `gstar_transpose` close and is not a target until the `_legs_conj` fallback lands.

## 1. QUOT coverage debt — blueprint the 3 new public decls (MEDIUM)

Per `lean-vs-blueprint-checker quot039` + `dag-query unmatched`, these new public decls have NO
blueprint entry (invisible to the dependency graph). The planner should author blocks next iter:
- `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_powers_transport` (QuotScheme ~1905) — combined
  bridge (I)+(II); depends on `isLocalizedModule_of_ringEquiv_semilinear`,
  `isLocalizedModule_restrictScalars_powers_algebraMap`, `Submonoid.map_powers`.
- `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_basicOpen_cover`
  (QuotScheme ~1665) — instantiable basic-open descent form; depends on `descent_surj`,
  `descent_smul_eq_zero`, `PrimeSpectrum.basicOpen_mul`. Blueprint prose for `lem:section_localization_descent`
  should note this is the **usable** form and that the general-U `_of_cover` form is an abandoned trap.
- `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_iso` (QuotScheme ~1936) — iso-invariance;
  depends on `isIso_fromTildeΓ_iff`, `Functor.essImage.ofIso`.

(The other 12 `unmatched` nodes are all `private` impl helpers — sanctioned, no blueprint owed.)

## 2. QUOT gap1 — proceed: build the geometric Hfr producer (MEDIUM, CONVERGING)

progress-critic verdict CONVERGING. Every algebra/category feeder is now in hand. The single remaining
wall is the **geometric Hfr producer**: the slice presentation ↔ scheme-pullback section transport over
`Spec R_r` that produces the per-cover `IsLocalizedModule` data. With that, instantiate
`isLocalizedModule_basicOpen_descent_of_basicOpen_cover` → close the named
`isLocalizedModule_basicOpen_descent` → gap1 `isIso_fromTildeΓ_of_isQuasicoherent`. This is the natural
iter-040 QUOT objective. The blueprint sketch for the producer (slice/scheme-pullback transport, σ's,
restriction-map intertwining) should be confirmed detailed enough before the prover round.

## 3. FBC blueprint adequacy + auditor minors (LOW)
- `lean-vs-blueprint-checker fbc039` minor: the `_legs_conj` blueprint sketch describes the
  conjugate-injectivity strategy but does not pin the concrete `adjL`/`adjR` needed to type the
  section-level LHS as a single `conjugateEquiv` value. Given the fallback pivot (§0), this is
  superseded — the planner should re-cut this blueprint node toward whichever fallback (A/B) is chosen
  rather than refine the abandoned reframing sketch.
- `lean-auditor iter039` minor: add a heartbeat-justification comment to `crossLayer` (`maxHeartbeats
  4000000`); stale inherited `iter-NNN` numbering is cosmetic.

## Do-NOT-retry standing notes (carried + updated)
- **FBC `_legs_conj` conjugate-component reframing** — kill-criterion FIRED iter-039. Do NOT dispatch
  another conjugate/assembly prover round on it. Pivot to fallback A or B (§0).
- **QUOT general-U `isLocalizedModule_basicOpen_descent_of_cover`** — unprovable trap. Use the
  basic-open form `..._of_basicOpen_cover` (landed this iter).
- **FBC element-`ext` WITHOUT the conj dictionary** — produced no normal form in iter-035. The conj
  atoms now supply the dictionary, so the §0 Option A reopening is NOT the same dead end; but do not
  reopen element-`ext` naively without wiring conj-2b/2c/2d in as the change-of-rings dictionary.
