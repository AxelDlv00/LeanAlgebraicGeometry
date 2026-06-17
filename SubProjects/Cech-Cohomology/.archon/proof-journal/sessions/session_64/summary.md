# Session 64 (iter-064) — summary

## Metadata
- **Iter / session:** 064 / session_64. Model: claude-opus-4-8.
- **Mode:** the planner's prescribed **mode-switch from mathlib-build to fine-grained** (the new
  structural element iter-063 lacked), executing the progress-critic's CHURNING corrective for both
  CHURNING+OVER_BUDGET routes: blueprint decomposition into atomic named sub-lemmas, then a
  fine-grained prover pass.
- **Real sorry (project, iter-063 END → iter-064 END): 9 → 12** — the increase is BY DESIGN. The
  two terminal-wall monoliths (CSI Stub-2 chain; OpenImm `case hqc`) were deliberately broken into
  small precisely-typed leaves. See the per-route accounting below.
- **Build: GREEN.** `lake env lean` EXIT 0 on `OpenImmersionPushforward.lean` (verified first-hand,
  exit 0, 5 honest sorry warnings: 588/644/654/687/910). CSI build re-verified (see below).
- **Lanes planned 2, ran 2.** Both PARTIAL. **3 genuine results closed** + both monoliths wired to
  atomic leaves. No papering (see Soundness).

## Per-route accounting (the count went up — here is exactly why)

### Lane 1 — CSI `CechSectionIdentification.lean` (within-file sorry 5 → 4)
The plan-phase scaffold had already wired the finite coproduct→product induction
(`pushPull_coprod_prod` via `Finite.induction_empty_option`) and the assemblies `pushPull_sigma_iso`
(Stub 2) and `pushPull_eval_prod_iso` (Stub 4), leaving the **3 induction-step leaves** (empty,
reindex, Option) + Stubs 5/6 = 5 file sorries entering the session.

- **CLOSED: `coprodToProd_isIso_option`** — the substantive Option-adjoining induction step (reuses
  the iter-063 ★ `pushPull_binary_leg_coherence`). Axiom-clean. This is the real forward motion.
- **PARTIAL `pushPull_coprod_prod_empty`** (line 983): reduced to a clean leaf
  `IsZero ((pullback q).obj F)` over the initial/empty scheme `∐ PEmpty`. No Mathlib one-liner;
  needs presheaf-of-modules IsZero-from-pointwise (~40–60 LOC).
- **PARTIAL `coprodToProd_isIso_of_equiv`** (line 999): mechanical `whiskerEquiv` reindex chase,
  not attempted (budget). All ingredients exist.
- Stubs 5/6 (`cechSection_complex_iso` 1358, `cechSection_contractible` 1417): untouched, downstream.

Net at the project level: CSI was 4 (Stubs 2/4/5/6) at iter-063 end, is 4 now (empty, reindex,
Stub 5, Stub 6) — **flat**, but with Stub 2 + Stub 4 now assembling sorry-free and the substantive
Option step closed.

### Lane 2 — OpenImm `OpenImmersionPushforward.lean` (within-file sorry 2 → 5)
The monolithic `case hqc` sorry of `higherDirectImage_openImmersion_acyclic` was decomposed into a
named chain and `case hqc` rewired.

- **CLOSED (body sorry-free, modulo leaves): `pushforwardSliceTwoAdjunction`** — assembled from
  `pushforwardPushforwardAdj` + the slice equivalence's adjunction. Continuity-on-`.symm.functor`
  defeq-not-syntactic instance trap cleared via explicit `haveI` bridges.
- **CLOSED (body sorry-free, modulo leaf): `pushforward_iso_preserves_qcoh`** — per-cover-member
  presentation transport across `pullback ψ_r` then `pushforwardSlicePullbackIso`, glued by
  `pushforward_iso_qcoh_of_slice_qcoh`. Forward-`have` style (avoids stuck `WEqualsLocallyBijective`
  metavars); `.{u}` pins; `maxHeartbeats`/`synthInstance.maxHeartbeats` bumps.
- **`case hqc` rewired** to `exact pushforward_iso_preserves_qcoh U.isoSpec H hH` — the `_acyclic`
  body is now sorry-free. ⚠️ This is NOT a real closure of `_acyclic`: it transitively depends on
  the 4 open leaves; `#print axioms` still reports `sorryAx`. (Prover was explicit about this.)
- **PARTIAL `pushforwardSlicePullbackIso`** (line 687/692): Step-1 `leftAdjointUniq` half built and
  compiles; residual = the `≪≫ sorry` Step-2 section identity (rfl-clean once φ'' concrete). `.{u}`
  pinning trap cleared.
- **PARTIAL `sliceReverseRingMap`** (φ'', line 588/607) — **the keystone.** First factor pinned
  (= over-pullback of `φ.hom.toRingCatSheafHom`, blueprint-correct); residual = the 2-part codomain
  bridge: (a) `sheafPushforwardContinuousComp'` (mechanical) + (b) the object-relabel iso
  `X.ringCatSheaf.over (φ.hom⁻¹ᵁ Vᵢ) ≅ (pushforward (Over.map (unitIso.inv.app Uᵢ))).obj (X.ringCatSheaf.over Uᵢ)`
  (the genuine ~40–80 LOC wall).
- **PARTIAL `pushforwardSliceAdjunctionH1`/`H2`** (lines 644/649, 654/660): statements extracted with
  exact types; bodies sorry; **blocked on φ'' being concrete** (then reduce to eqToHom squares).
- `higherDirectImage_openImmersion_comp` (`_comp`, line 910/934): unchanged sorry.

Net at the project level: OpenImm was 2 (`hqc`, `_comp`) → 5 (φ'', H1, H2, pullbackIso, `_comp`).
**Everything hinges on the single keystone φ''.**

## Soundness — confirmed, no papering
- **`lake env lean` EXIT 0** first-hand on OpenImm (5 honest sorry warnings); CSI re-verified.
- Prover `lean_verify` (in-session): `coprodToProd_isIso_option`, `pushPull_binary_coprod_prod_hom`,
  `coprodToProdMap_comp_π` all `{propext, Classical.choice, Quot.sound}` (axiom-clean); the still-open
  decl correctly reports `sorryAx`.
- The `case hqc` rewiring is honest: `higherDirectImage_openImmersion_acyclic` is NOT listed under
  "uses sorry" in its own body, but transitively depends on open leaves — flagged here and in
  recommendations so no downstream "done" check is fooled.
- No new `axiom` declarations (blueprint-doctor: no findings). No thin-cat `ext`/`congr` laundering
  this iter (the closures are genuine term-mode / projection-chase proofs).

## Key findings / reusable patterns (see PROJECT_STATUS Knowledge Base)
- **erw-vs-rw for push–pull projections.** `prod.lift_fst`/`prod.lift_snd_assoc`/`Pi.lift_π` over
  push–pull product objects fire ONLY under `erw` (defeq matching), never `rw`/`simp only`.
- **beta-redex product mismatch → `let`-bind to an fvar.** `coprodToProdMap F (fun a => legs (some a))`
  carries an unreduced redex; `let ls := fun a => legs (some a)` makes the products syntactically
  identical across the binary leg and the IH.
- **reverse `← pushPullMap_comp` whnf-timeout → forward-fold via `heq`.** Prove the over-morphism
  identity once, `rw [heq]`, then expand with forward `pushPullMap_comp` (cheap head-match).
- **IsContinuous on `.symm.functor` is defeq-not-syntactic** → instance search fails; bridge with
  explicit `haveI`.
- **Universe pinning** `SheafOfModules.pullback.{u}` / `pullbackPushforwardAdjunction.{u}` — defaults
  to 0 and breaks the downstream `Presentation` universe match.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:pushPull_coprod_prod`: replaced stale
  `% NOTE: ...does not exist yet` with an iter-064 BUILT note (decl exists; threads the 2 residual
  induction leaves empty/reindex).
- `Cohomology_CechHigherDirectImage.tex`, `lem:pushforward_slice_two_adjunction`: replaced stale
  `% NOTE: ...does not exist yet` (decl now exists, body sorry-free modulo H1/H2).
- `Cohomology_CechHigherDirectImage.tex`, `lem:pushforward_slice_pullback_iso`: replaced stale NOTE
  (decl exists; Step-1 built; residual = Step-2 `≪≫ sorry`).
- `Cohomology_CechHigherDirectImage.tex`, `lem:pushforward_iso_preserves_qcoh`: replaced stale NOTE
  (decl exists, body sorry-free modulo pullbackIso leaf; `case hqc` `exact`s it).
- No `\mathlibok` added (no new Mathlib-re-export project leaf this iter). No `\lean{}` rename
  (all blueprint names already match). No stale `\notready` (none present).

## Subagent verdicts
See `## Subagent verdicts` resolution in `recommendations.md` and `iter/iter-064/review.md`.
(lean-auditor iter064, lvb-csi iter064, lvb-openimm iter064 — dispatched this phase.)

## Recommendations
See `recommendations.md`. Headline: this iter executed the prescribed structural corrective; the
next round is a **single keystone dispatch on φ'' (`sliceReverseRingMap`)** for OpenImm (everything
else falls once it lands) and a **prove pass on the 2 CSI induction leaves** (empty IsZero-over-empty
-scheme + whiskerEquiv reindex). Both are now small, precisely-specified, non-monolithic targets.
