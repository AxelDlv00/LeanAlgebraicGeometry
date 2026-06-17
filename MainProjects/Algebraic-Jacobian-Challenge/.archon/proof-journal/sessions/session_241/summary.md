# Session 241 — review of iter-241

## Metadata
- **Iteration / session:** 241.
- **Prover lanes:** 2, both `partial→productive` (each landed an axiom-clean canonical declaration).
- **Sorry deltas (per file):**
  - `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`: **3 → 2** (`pushforward_spec_tilde_iso` closed).
  - `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`: **2 → 2** (`pullbackUnitIso` added sorry-free;
    the 2 remaining are the pre-existing deferred dual-bridge sorries, untouched).
- **Net canonical sorry movement: −1** (the first canonical elimination since iter-238).
- **Build:** GREEN both files (`lake env lean` exit 0; only `Sheaf.val` deprecation + long-line style
  warnings).
- **sync_leanok:** iter 241, sha `802f4318`, **+16 / −0**, chapters `Cohomology_FlatBaseChange.tex`,
  `Picard_TensorObjSubstrate.tex`.

## The headline — both walled lanes broke through in the SAME iter

This is the iter where the two trip-wires the iter-241 plan armed were both honoured by *success*,
not pivot:

- **Lane B (FlatBaseChange) trip-wire:** "if `pushforward_spec_tilde_iso`'s sorry count does not
  strictly decrease, Route B PAUSES → Mathlib bump #37189." It **decreased** (closed axiom-clean).
  The 4-iter `Module.compHom`/`restrictScalars` carrier wall (iters 234/235/236/239/240) is fully
  resolved. Route B continues; the #37189 bump is NOT needed.
- **Lane A (TensorObjSubstrate):** the Phase-1 PRIMARY `pullbackUnitIso` landed axiom-clean — and
  the prover found a *strictly simpler* route than the blueprint/plan prescribed (see MAJOR FINDING).

I re-verified both first-hand: `lean_verify` on `AlgebraicGeometry.pushforward_spec_tilde_iso` and
`AlgebraicGeometry.Scheme.Modules.pullbackUnitIso` both return exactly
`{propext, Classical.choice, Quot.sound}`. **No laundering** — the `lean_verify` source-scan "opaque"
flag at TensorObjSubstrate L488 is the word "opaque" inside a comment (verified by reading L485–488),
not an axiom.

## Target 1 — `pushforward_spec_tilde_iso` (FlatBaseChange.lean) — SOLVED

The single residual was the open-naturality square `hsq : ρ ≫ e₂.hom = e₁.hom ≫ Gmor` inside
`pushforward_spec_tilde_iso`. iters 237–240 fought it with ~15 `rw`/`simp`/`slice`/`conv`/`reassoc_of%`
forms, all failing to unify a `restrictScalarsComp'App … .inv` subterm baked into `gammaPushforwardIsoAt`.

**Decisive fix (two parts):**
1. **Refactored `gammaPushforwardIsoAt`'s middle iso** from
   `eqToIso (congrArg (fun h => (ModuleCat.restrictScalars h).obj SecN) hcomp)` to
   `(ModuleCat.restrictScalarsCongr hcomp).app SecN`. `restrictScalarsCongr` is built from
   `AddEquiv.refl`, so it is identity-on-carrier with a clean `rfl` apply-lemma — this deletes the
   *only* non-`rfl` cast in the construction. Same type; consumer-safe.
2. **`hsq` then closes by `ext x; rfl`.** Once the `eqToIso` is gone, every constituent of `e_U`'s
   `.hom`/`.inv` (`restrictScalarsComp'App_{hom,inv}_apply`, `restrictScalarsCongr` app,
   `restrictScalars.map_apply`) is `rfl`-identity on the underlying carrier (`restrictScalars` never
   changes the carrier type), so both legs send `x` to the underlying `tForget x` definitionally.

Attempts (from `attempts_raw.jsonl`):
- The intermediate `simp only [..., ModuleCat.restrictScalarsCongr_hom_app]` and
  `simp only [..., Iso.app_hom, ...]` forms (lines 31, 35, 37 of the raw log) still left a residual /
  long-line error — the prover narrowed to plain `ext x; rfl` once part (1) was in place (raw log
  line 39, diagnostics clean line 40).

This is the cleanest realization of the planner's "NatIso refactor" directive: rather than packaging
the family as a `NatIso` and invoking `.naturality`, the same idea (every component is a ring-structure
repackaging) is exploited directly at the element level.

## Target 2 — `pullbackUnitIso` (TensorObjSubstrate.lean) — SOLVED + MAJOR FINDING

### MAJOR FINDING (de-risks the whole §6 lane)
**`SheafOfModules.pullbackObjUnitToUnit f` is an isomorphism for EVERY morphism of schemes `f`, not
only `Final`-chart ones.** The Mathlib instance `instIsIsoPullbackObjUnitToUnitOfFinal` requires
`(Opens.map f.base).Final`, and that holds *unconditionally*: the preimage functor on opens preserves
finite limits (frame homomorphism) ⇒ is representably flat ⇒ `CategoryTheory.final_of_representablyFlat`
supplies `(Opens.map f.base).Final` for any `f`.

**Consequence:** the elaborate affine chart-chase the blueprint demanded for `lem:pullback_unit_iso`
(and even the iter-240 coherence linchpin `pullbackObjUnitToUnit_comp`) is **unnecessary** for the unit
iso. The prover built the full chart-chase (`isIso_restrict_pbu`, axiom-clean) but did NOT commit it —
it is made redundant by the one-line representable-flatness argument. `pullbackObjUnitToUnit_comp` is
retained (genuine Mathlib-absent pseudofunctor coherence; the most plausible ingredient for the harder
Phase-2 tensor comparison).

### The TC accident (resolved, reusable idiom)
The mathlib-analogist's `pbu-canon` diagnosis was real but only a proof-tactic issue: with several
`(Opens.map _).Final` in scope, the buried implicit instance args of `pullbackObjUnitToUnit`
(`[F.IsContinuous]`, `[(pushforward φ).IsRightAdjoint]`) are defeq-but-not-syntactic, so
`asIso`/`infer_instance` fails at *reducible* transparency. Fix (raw log lines 92, 94):
1. `private lemma isIso_pbu_of_final g [(Opens.map g.base).Final] : IsIso (pbu g) := inferInstance`
   — isolates the lone `Final` so `inferInstance` runs at a clean site.
2. `pullbackObjUnitToUnitIso g := @asIso _ _ _ _ (pbu g) (isIso_pbu_of_final g)` — pass the witness
   EXPLICITLY; the `@asIso` typecheck is `isDefEq` at **default** transparency, which succeeds even
   though reducible-transparency synthesis does not.

## Still open (correctly NOT closed this iter)
- **`affineBaseChange_pushforward_iso`** (FlatBaseChange L682, BLOCKED): with
  `pushforward_spec_tilde_iso` now in hand, the affine close still needs (3) the Mathlib-absent
  pullback-of-tilde dictionary `pullback (Spec.map φ) (tilde M) ≅ tilde (R' ⊗_R M)` and (4) recognising
  the abstract `pushforwardBaseChangeMap` adjoint-mate as
  `TensorProduct.AlgebraTensorModule.cancelBaseChange`. A separate ~hundreds-LOC engine sub-lane; the
  blueprint itself (L980–985) calls it "a multi-lane engine build, not a single-iter target." Documented
  partial preserved, no bare sorry.
- **`flatBaseChange_pushforward_isIso`** (FlatBaseChange L704): explicitly out of scope (deep Čech +
  flatness), per objectives.
- **`pullbackTensorIso`** (Phase 2) / **`IsInvertible.pullback`** (Phase 3, TensorObjSubstrate): Phase 2
  is a genuine Mathlib-absent build — no tensor-pullback comparison map, no `MonoidalCategory
  (SheafOfModules)` at the pinned commit; `Scheme.Modules.pullback` is an abstract left adjoint, so
  there is no canonical map to even *state* the iso, and the `OfFinal` unit trick does not generalise.
  The prover correctly left both ABSENT (no sorry pin) and handed off a multi-hundred-LOC decomposition.

## Blueprint markers updated (manual)
None this iter. Both new decls are project constructions (not Mathlib re-exports), so no `\mathlibok`.
No `\lean{...}` renames (prover used the blueprint-pinned names). No stale `\notready` present. The
proof-block `\leanok` on `lem:pushforward_spec_tilde_iso` and `lem:pullback_unit_iso` are owned by
`sync_leanok` (+16 this iter) — left untouched.

## Structural issue — sync_leanok mis-inserted `\leanok` inside two `\uses{...}` braces (NOT my domain)
The blueprint-doctor flagged two "broken cross-refs" in `Cohomology_FlatBaseChange.tex`:
`\uses{\leanok lem:fromTildeGamma_app_isIso_of_localized}` and
`\uses{\leanok lem:pushforward_spec_tilde_iso_conditional}`. Root cause (single): `sync_leanok` inserted
a `\leanok` token on its own line *inside* a multi-line `\uses{...}` brace at **L500** and **L551** (the
`\uses{` opens on L499/L550 immediately after `\begin{proof}`). This both (a) breaks the two `\uses`
dependency edges and (b) mis-places the proof-block marker. The referenced labels DO exist (L450, L482);
the only defect is the marker position. This is a `sync_leanok`/`\uses{}`-structure bug — `\leanok` is
the sync's domain and the `\uses{}` prose is the plan agent's; **neither is the review agent's to edit**.
Surfaced in `recommendations.md` for the next plan iter. See Knowledge Base note on multi-line `\uses{}`
directly after `\begin{proof}`.

## Review subagents
Dispatched lean-auditor (both files) + lean-vs-blueprint-checker ×2 (one per modified file). Findings
landed in `recommendations.md`; reports at `task_results/{lean-auditor-ts241,
lean-vs-blueprint-checker-fbc, lean-vs-blueprint-checker-tos}.md`.

## Recommendations (see recommendations.md for detail)
1. Fix the `sync_leanok`-misplaced `\leanok`-in-`\uses{}` at FlatBaseChange L500/L551 (plan agent).
2. Lane A: scope/dispatch the Phase-2 `pullbackTensorIso` sub-lane (multi-hundred-LOC, Mathlib-absent)
   OR check a Mathlib bump; simplify the over-engineered `lem:pullback_unit_iso` chart-chase prose.
3. Lane B: `pushforward_spec_tilde_iso` DONE; `affineBaseChange_pushforward_iso` needs its own
   pullback-of-tilde sub-lane scoped before any prover round — do NOT re-dispatch as a single-iter close.
