# iter-060 review

## Overall progress this iter
- **Total real sorry:** 11 → **9** (−2, two genuine closures, **none forced/papered**). Closed: `cechBackbone_left_sigma` (CSI Stub 1) and the `hjt` leaf via `jShriekOU_transport_along_iso` (OpenImm). (`grep -c sorry` reports 10 because `CechAcyclic.lean:18` says "sorry" inside a docstring; the only real `CechAcyclic` hole is the dead `affine` at 110.) Open holes: `CechSectionIdentification:652/739/803/870` (Stubs 2,4,5,6), `OpenImmersionPushforward:532` (`hqc`) + `:598` (`_comp`), `CechAugmentedResolution:229`, `CechHigherDirectImage:780` (frozen P5b), `CechAcyclic:110` (dead).
- **Build:** GREEN. Re-verified first-hand — `lake env lean` EXIT 0 on both prover files; `#print axioms` = `{propext, Classical.choice, Quot.sound}` on `cechBackbone_left_sigma`, `widePullbackBaseCongr`, `coverInterProdIso`, `jShriekOU_transport_along_iso`.
- **Lanes planned 2, ran 2.** Both PARTIAL-with-keystone-closure. **+5 axiom-clean decls** (3 CSI + 2 OpenImm helpers, plus the two closed keystones).
- **dag-query:** gaps = 0; unmatched = 5 (4 new helpers + dead `affine`). sync_leanok ran iter-060 (sha `177bdc0`, +5/−2). **blueprint-doctor: no findings.**

## Headline 1 — CSI Stub 1 closed: the iter-057 churning route fully converged
`cechBackbone_left_sigma` — the geometric backbone identification that has been the gating CSI node since iter-056 — is now axiom-clean. It landed exactly on the iter-059-prescribed **universe-reduction** route: reindex `𝒰.I₀ ≃ Fin (Nat.card 𝒰.I₀)` so the Type-0-only extensivity primitive `isIso_sigmaDesc_fst` applies, run `widePullback_coproduct_iso` at Type 0, transport back with `Sigma.whiskerEquiv` + `Sigma.mapIso coverInterProdIso`. The decomposition discipline (iter-058 effort-break → iter-059 build the bricks → iter-060 assemble) paid off: every brick existed, and assembly was a clean ~40-LOC composition plus two small helpers. Stub 1 no longer gates Stubs 2→4.

## Headline 2 — Need #1 `hjt` closed; one geometric leaf (`hqc`) left
`jShriekOU_transport_along_iso` discharges `case hjt` in `higherDirectImage_openImmersion_acyclic`. The prover **improved on the blueprint sketch**: instead of `compCoyonedaIso` + `coyoneda_fullyFaithful`, it built two `CorepresentableBy` witnesses for the same functor and used `CorepresentableBy.uniqueUpToIso`. With the homological half (iter-059) and `hjt` (iter-060) both done, the **sole remaining Need #1 residual is `hqc`** — qcoh-preservation of `pushforward φ H` along the scheme iso. The prover confirmed by exhaustive Mathlib grep that no over/pushforward commutation or qcoh-under-equivalence lemma exists; the two blueprint-named deps (`pushforward_commutes_restriction`, `pushforward_iso_preserves_qcoh`) are still unbuilt. This is a decompose-first node, NOT a re-throw.

## Soundness — confirmed three ways, no papering
- **Review first-hand:** both `lake env lean` EXIT 0; 4 keystones kernel-clean.
- **lean-auditor `iter060`** (0 must-fix): both edited files clean; all 3 new CSI + 3 new OpenImm decls genuine (the auditor specifically confirmed `cechBackbone_left_sigma` is NOT a Subsingleton/defeq launder, and both `sectionsCorep*` witnesses corepresent the same functor); all sorries honest with correct goal types; no excuse-comments. One minor: the `CechAugmentedResolution.lean:229` sorry comment ("signature-level compile errors" in CSI) may now be stale.
- **lvb-csi** (0 red flags) + **lvb-openimm** (1 must-fix = a stale blueprint `% NOTE:`, **fixed this review**). Neither must-fix is Lean unsoundness.

## The traps worth carrying forward (all caught by `lake env lean`, not the LSP)
1. **Hom-universe metavar no-op:** a generic-`{C}` categorical helper (`widePullbackBaseCongr`) had a hom-universe metavar that silently made `rw`/`simp` on composites do nothing — specialize to `Scheme`.
2. **All-underscore stuck instance:** `IsOpenImmersion.lift_fac _ _ _` left an unsynthesizable instance metavar that the LSP reported **clean** but `lake env lean` rejected — reorder `refine … ?_ ; exact lift_fac _ _ _`.
3. **`Sigma.whiskerEquiv` index family:** must pass `f:=`/`g:=` explicitly or the `sigmaObj` family stays a metavar.

These reinforce the standing rule (memory `stub1-done-categorical-helper-traps`): re-verify every "LSP-clean" categorical helper with `lake env lean` + `#print axioms`.

## Markers I changed
Stripped the stale `% NOTE: build target. The Lean declaration does not exist yet.` from `lem:jshriek_transport_along_iso` (line 9510) — the decl now exists axiom-clean. **Left in place** the identical NOTEs on `lem:pushforward_commutes_restriction` (9583) and `lem:pushforward_iso_preserves_qcoh` (9625): I grepped both — neither declaration exists yet, so those NOTEs are accurate (they are the `hqc` residual's unbuilt deps).

## Follow-ups handed to the planner (in session_60/recommendations.md)
- **Ready:** CSI Stubs 2/4 (`pushPull_sigma_iso`, `pushPull_eval_prod_iso`) — consume the now-closed backbone; clear the HARD GATE then dispatch.
- **Blocked (decompose first):** `hqc` / `higherDirectImage_openImmersion_comp` — effort-breaker on `lem:pushforward_iso_preserves_qcoh` and/or mathlib-analogist cross-domain.
- **Coverage debt:** 4 new helpers need blueprint blocks (`widePullbackBaseCongr`, `coverInterProdIso`, `sectionsCorep`, `sectionsCorepPushforward`).
- **Blueprint maintenance (planner-owned):** `lem:jshriek_transport_along_iso` `\uses` is stale (proof uses `uniqueUpToIso`); 4 sorry-free blocks missing `\leanok` (verify `\lean{}` names resolve so next sync picks them up).
- **Lean comment (prover/refactor):** refresh the stale `CechAugmentedResolution.lean:229` comment.

## Subagent skips
- (none — both HIGHLY RECOMMENDED review subagents dispatched: lean-auditor `iter060`, lean-vs-blueprint-checker on both prover-touched files.)
