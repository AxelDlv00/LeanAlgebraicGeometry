# Iter-035 plan — 02KG cover-system Cov correctness FIXED; TildeExactness gate-cleared (fast-path); P1a opens

## Entering state (verified)
iter-034's two lanes processed:
- **Lane A `AffineSerreVanishing.lean` — 02KG cover-system COMPLETE (+4 axiom-clean):**
  `toSheaf_preservesFiniteColimits`, `toSheaf_preservesEpimorphisms`, `affine_surj_of_vanishing`,
  `affineCoverSystem`. BUT carried the latent Cov flaw the iter-034 review caught (see Decision D1).
- **Lane B `TildeExactness.lean` — PARTIAL (+2 axiom-clean):** `tilde_stalkFunctor_map_toStalk` (germ-naturality
  CRUX) + `tildePreservesFiniteLimits_of_toPresheaf` (categorical reduction). Named target ABSENT.
- Project sorry = 2 (both frozen/superseded). Build green.

## Decisions made

### D1 — `affineCoverSystem.Cov` is genuinely broken; tighten the LEAN (adjudicated, then fixed this iter).
The iter-034 reviewers DISAGREED: lean-auditor said the over-broad `Cov` (all finite basic-open families, no
covering condition) makes `HasVanishingHigherCech` FALSE for qcoh and the seed unprovable; lvb-affine said the
broad Cov is "sound, relax the prose." **I adjudicated for the auditor** and independently verified the
disproof: for the NON-covering family `{D(x),D(y)}` on `Spec k[x,y]`, the unaugmented Čech complex is
`R_x×R_y → R_{xy}` whose cokernel contains `x⁻¹y⁻¹ ∉ R_x+R_y`, so `Ȟ¹(O)≠0`. The lvb's "sections over the
total intersection equal a localised module, hence exact" reasoning conflates the total-intersection section
with the *complex's cohomology* — exactness needs the augmentation by `R`, i.e. the covering condition. So the
broad Cov is wrong; the fix is to tighten the Lean (the prose is already correct).
- **Why this matters now:** the just-built `affineCoverSystem` materialized the flaw in Lean. Fixing it BEFORE
  any downstream consumer (the qcoh seed) is correct and cheap.
- **The fix (well-scoped, NOT protected):** `Cov := {c | ∃ n g f, c=⟨ULift(Fin n), i↦D(g i.down)⟩ ∧
  D(f)=⨆ᵢD(g i.down)}`; re-sign `affine_surj_of_vanishing`'s `hvanish` to take a `(f')` + covering-witness
  premise, fed by `hUsup`/`hVeq` from `standard_cover_cofinal` (line 270/272) — the proof already produces the
  covering witness. The three field proofs just thread/ignore the extra witness. Executed via the **refactor
  subagent** (signature/def change), EXIT 0, no sorry, both decls axiom-clean (independently `lean_verify`'d
  `{propext, Classical.choice, Quot.sound}`).
- **Reversal signal:** none — the counterexample is decisive; the prover's task-note "broader Cov only
  strengthens" is wrong and was NOT accepted.

### D2 — This iter's two PROVER lanes: TildeExactness continuation + NEW P1a geometry file.
- **TildeExactness** (CONVERGING per progress-critic): assemble `tildePreservesFiniteLimits` from the
  R-linear `σ_x` packaging + jointly-reflecting stalk-family assembly. The germ-naturality crux landed
  iter-034, so this is genuine forward progress (the blocker phrase changed); not the iter-034 watchpoint
  trigger (which fires only on a 3rd PARTIAL on the SAME blocker, now pushed to iter-036).
- **P1a `QcohRestrictBasicOpen.lean` (NEW)**: build `modules_restrict_basicOpen` (frontier, gate PASS) →
  `tilde_restrict_basicOpen` → `presentation_restrict_basicOpen`. Verified Mathlib handles found this iter:
  `Scheme.Modules.restrict` + `basicOpenIsoSpecAway f : ↥D(f)≅Spec(Localization.Away f)`. NOT the top
  `isQuasicoherent_restrict_basicOpen` (assembly step under-specified — clarify the `IsQuasicoherent` Lean
  definition before that lane, ~2–3 iters out).

### D3 — Do NOT dispatch the FALSE-ready frontier nodes.
`lem:affine_cech_vanishing_qcoh` (02KG seed) and `lem:cech_augmented_resolution` (P5a) read "Ready to prove"
in leandag, but their `\uses` under-declares the real dependence on the UNCONDITIONAL 01I8
`qcoh_iso_tilde_sections` / on `affine_serre_vanishing`. Both are genuinely blocked; dispatching them would
burn a lane. Validated the frontier rather than trusting "ready."

## What I did this iter (plan phase)
1. Processed both lanes (task_done += 6 decls + Cov fix; task_pending header refreshed; PROGRESS rewritten).
2. **progress-critic `iter035`: CONVERGING ×2**, dispatch OK. TildeExactness watchpoint → iter-036.
3. **blueprint-reviewer `iter035` (whole blueprint) HARD GATE:** `lem:modules_restrict_basicOpen` PASS →
   dispatch P1a L1; `lem:tilde_preserves_kernels` had 2 must-fixes.
4. **refactor `cov-fix`:** tightened `affineCoverSystem.Cov` + re-signed `affine_surj_of_vanishing` (D1).
5. **Authored the `lem:tilde_preserves_kernels` fixes myself** (planner prose + `\lean{}`): bundled the 2
   iter-034 helpers into `\lean{}`; extended the proof sketch with sub-steps (A) R-linearity, (B)
   stalkwise-iso⟹sheaf-iso, (C) reduction-to-Ab-presheaf-composite (helper names in `% NOTE`).
6. **blueprint-reviewer `tilde-rereview` (fast-path, scoped to `lem:tilde_preserves_kernels`): CLEARS**
   (`complete:true, correct:true, no must-fix`) → TildeExactness dispatchable this iter.
7. Added `modulesRestrictBasicOpenIso` to `lem:modules_restrict_basicOpen` `\lean{}` (pre-empt coverage debt).
8. STRATEGY refresh (02KG row: cover-system+Cov done, Iters-left ~1, top theorems FALSE-ready/gated; 01I8 row:
   P1a ACTIVE with verified handles). Wrote PROGRESS, task ledgers, this sidecar, objectives.md, TO_USER.md.

## Subagent skips
- strategy-critic: STRATEGY.md edits this iter are estimate-refreshes + a within-route correctness-fix note
  only (the Cov fix CONFIRMS, not changes, the 02KG/01I8 routes; no route swap, no decomposition change). Prior
  verdict SOUND, no live CHALLENGE. The Cov-soundness question is a Lean-level encoding issue already
  adjudicated by the lean-auditor + my independent counterexample check — not a strategy-level fork.
- blueprint-clean: I authored the `lem:tilde_preserves_kernels` extension directly as plan agent (not via a
  blueprint-writer round); kept rendered prose math-only with Lean names confined to `% NOTE`; the fast-path
  scoped re-review confirmed citation discipline clean. (blueprint-clean is required after a *writer* round.)

## Risks / watch
- TildeExactness: a 3rd PARTIAL on the same R-linearity/jointly-reflecting blocker at iter-036 → CHURNING →
  mathlib-analogist consult on the stalk-transport / jointly-reflecting idiom.
- P1a `modules_restrict_basicOpen`: first lemma of a hard geometry chain — UNCLEAR until ~2 iters of data.
- New file `QcohRestrictBasicOpen.lean` needs root-barrel import next iter (refactor) — established pattern.
