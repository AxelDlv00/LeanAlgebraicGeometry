# Session 33 (iter-033) — Review Summary

## Metadata
- Iteration / session: 033 / session_33
- Active sorry per file (before → after this iter):
  - `FlatBaseChange.lean`: 4 → 4 (`_legs` @1495, `gstar_transpose` @1744, affine @2017, FBC-B-target @2057)
  - `FlatBaseChangeGlobal.lean`: NEW file → 0 sorry (3 decls)
  - `GrassmannianCells.lean`: 0 → 0
  - `QuotScheme.lean`: 4 → 4 (protected stubs @126/165/201/228)
  - `FlatteningStratification.lean` (GF): 1 → 1 (untouched, gated on gap1)
- Net: **0 active sorry eliminated; +14 axiom-clean declarations.** Infrastructure iter.
- `#print axioms` on every new decl = `{propext, Classical.choice, Quot.sound}` (verified by prover via `lean_verify`).
- `lake build` green on all four edited modules.
- blueprint-doctor: **0 structural findings**.
- `sync_leanok` ran on the current tree (iter 33, sha `055b106`): **+10 `\leanok`, 0 removed**; chapters touched = FlatBaseChange / GrassmannianCells / QuotScheme.
- leandag: `gaps=0`, `unmatched=14` (coverage debt — see recommendations.md).

## Headline event — FBC-A "one final round" override FAILED → pivot now mandatory
The iter-033 plan took the progress-critic's enumerated override ("one final direct-on-sections round
with the declaration-ordering fix") against the standing FBC **STUCK** verdict, under an unconditional
commitment (plan.md condition (b)): *if `_legs` does not close, abandon direct-on-sections and pivot to
the ModuleCat re-encoding.* The round did NOT close `_legs`. **The pivot trigger has fired.**

What the round DID land: the surviving trailing transparent `pushforwardComp(g', Spec φ).hom` factor —
the one PROGRESS flagged as resisting keyed collapse — was collapsed to `𝟙` in the locked `_legs` goal
via a term-mode `congrArg` splice (`keyPFC := gammaMap_pushforwardComp_hom_eq_id …`), verified green by
`lake build` and by `lean_goal` (the factor is gone). This is a genuine but small mechanism advance.

What it definitively ruled out (do not re-try): the residual is **cross-layer naturality**, not adjacency
bookkeeping. The F2 (`e.hom`-unit) and F3 (`pullbackComp(e,inclA)`) cancellers live in the
`(Spec φ)_* ⋙ Γ_R` image (over `Spec R`); their codomain-read partners live in the
`Γ_R' → gammaPushforwardIso ψ → restrictScalars ψ` image (over `Spec R'`). Cancellation requires the
naturality of `gammaPushforwardIso ψ` as a `conjugateEquiv`/mate coherence (the device that closed Seam 1
`base_change_mate_unit_value`), which the explicit-factor route cannot express in term mode. Re-confirmed
once more this iter: keyed `rw`/`simp`/`erw`/`conv` are all dead against the `X.Modules` instance diamond —
even for a factor whose `=𝟙` is `rfl`-provable, `kabstract` cannot locate it. Full handoff:
`informal/base_change_mate_fstar_reindex_legs.md`.

## Per-target detail (see milestones.jsonl for code/errors)

### FBC-A — `base_change_mate_fstar_reindex_legs` (PARTIAL, crux ruled out)
Term-mode PFC-factor collapse landed; cross-layer naturality crux blocks the explicit-factor route
permanently. `gstar_transpose` is transitively gated on `_legs` (same crux), untouched.

### FBC-B — `FlatBaseChangeGlobal.lean` (PARTIAL, lane advanced, independent of FBC-A)
New split-out file. 3 axiom-clean decls realize the strategy-critic's parallelism corrective:
- `Scheme.exists_finite_affineCover_inter_isQuasiCompact` (L1) — finite affine cover of a qcqs scheme
  with quasi-compact pairwise overlaps (from `isCompact_iff_finite_and_eq_biUnion_affineOpens` +
  `quasiSeparatedSpace_iff_forall_affineOpens`).
- `Modules.gammaIsLimitSheafConditionFork` — the sheaf-condition fork is a limit (equalizer of products),
  via `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts`.
- `Modules.exists_finite_affineCover_isLimit_sheafConditionFork` — consolidation: `Γ(X,M)` is the
  equalizer of the finite sheaf-condition fork. This is the "finite equalizer" input of FBC-B.
The FBC-B keystone (`affine_base_change_pushforward` @2017 + FBC-B-target @2057 in the original file)
is NOT yet assembled.

### GR-sep — `isSeparated` (PARTIAL, ring heart + e₂ done, keystone not assembled)
6 axiom-clean decls: the complete ring-theoretic heart of separatedness
(`transitionPreMap_minorDet_swap_mul`, `diagonalRingMap`, `diagonalRingMap_left/right`,
**`diagonalRingMap_surjective`** — the Proj-analogue's hardest ingredient) plus the e₂ source iso
`pullbackιIso` (`pullback (ι i) (ι j) ≅ chartOverlap`). The keystone `Grassmannian.isSeparated` was NOT
assembled: a sorry'd `isSeparated_dev` stub was built (reduction skeleton compiles) then **removed** under
the no-sorry invariant, leaving only a doc-comment reduction. Remaining: per-patch closed immersion from
the surjective comorphism + target iso + terminal-vs-`Spec ℤ` reconciliation (absent from the Proj
template) + two-leg `hom_ext`. Notable: `Semiring (TensorProduct ℤ (MvPolynomial …) …)` is NOT found by
`inferInstance` / explicit annotation — drop the return-type annotation and let elaboration infer it.

### QUOT-P1 — `isIso_fromTildeΓ_restrict_basicOpen` (PARTIAL, 4 infra decls, target not built)
4 axiom-clean decls: `isIso_unitToPushforwardObjUnit_of_isIso'` (private helper),
`overRestrictUnitIso` (slice-to-geometric unit iso via the `IsIso ψ` route, ψ=𝟙 — the `PullbackFree`
finality route is unavailable on the slice site), `overRestrictPresentation` (slice→geometric
Presentation transport), `presentationPullbackιOfQuasicoherentData` (per-element over a
`QuasicoherentData`). The last needs a mandatory elaboration triple: `maxHeartbeats 2000000` +
`synthInstance.maxHeartbeats 800000` + `backward.isDefEq.respectTransparency false`; the `set_option`
lines must sit ABOVE the doc-comment (not between it and the `def`). The assigned keystone was deferred —
the round budget went to the prerequisites.

## Key findings / patterns
- **FBC direct-on-sections is exhausted.** The cross-layer naturality crux has no term-mode expression;
  the `X.Modules` diamond defeats every keyed tactic. iter-034 MUST pivot (STRATEGY Open Q2 arm a:
  re-encode at the ModuleCat/SheafOfModules level so the diamond never forms). Do NOT re-assign a
  direct-on-sections/wrapper round on `_legs`.
- **`TensorProduct ℤ` of `MvPolynomial` rings**: `inferInstance` / explicit `Semiring (...)` annotation
  fails to synthesize; omit the type annotation and let elaboration infer it. (memory:
  `tensorproduct-mvpolynomial-semiring-inferinstance-miss`)
- **SheafOfModules slice-presentation transport** elaboration tricks captured in memory
  `sheafofmodules-slice-presentation-transport-tricks`: `overRestrictEquiv.functor` is definitionally a
  `pushforward`; unit-iso via `IsIso ψ`; `.{u}` on `Presentation.map`/`ofIsIso`; heartbeat triple; the
  `set_option`-above-docstring ordering gotcha.
- **No-sorry invariant has a cost**: both GR and QUOT built compiling reduction skeletons with a single
  residual `sorry`, then DELETED them to keep the file sorry-free — so a half-done keystone shows as
  "0 sorry / decl absent" rather than "1 sorry / decl present". This makes count-based progress
  misleading; judge these lanes by the infra landed, not the sorry delta.

## Subagent dispositions
See `recommendations.md` for the landed findings from this review's subagents:
- `lean-auditor iter033` (all 4 files) — report: `task_results/lean-auditor-iter033.md`
- `lean-vs-blueprint-checker` × 3 (FBCGlobal / GrassmannianCells / QuotScheme) — reports in `task_results/`

## Blueprint markers updated (manual)
- `Picard_GrassmannianCells.tex`, `lem:gr_separated`: added `% NOTE` (iter-033) — pinned decl
  `Grassmannian.isSeparated` does not yet exist; ring heart (`diagonalRingMap_surjective`) + e₂ iso
  (`pullbackιIso`) landed, keystone glue assembly remaining; sorry'd `isSeparated_dev` was removed.
- No `\mathlibok` added: all 14 new decls are project-local genuine proofs (not Mathlib re-exports).
- QUOT `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`: existing `% NOTE` ("pinned decl …
  isIso_fromTildeΓ_restrict_basicOpen does NOT yet exist") re-verified accurate — left as-is.
