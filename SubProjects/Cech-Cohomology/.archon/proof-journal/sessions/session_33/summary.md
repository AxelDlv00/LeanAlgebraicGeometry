# Session 33 review (iter-033)

## Metadata
- **Total sorry**: 2 → 2 (no change; both frozen/superseded — `CechAcyclic.lean` dead `affine`,
  `CechHigherDirectImage.lean:679` frozen P5b). New file `TildeExactness.lean` is **0-sorry**.
- **Build**: GREEN. `TildeExactness.lean` `lake env lean … EXIT 0`, `lean_diagnostic` empty; all
  3 delivered decls `lean_verify` axiom-clean `{propext, Classical.choice, Quot.sound}`.
- **Lanes planned**: 2 (Lane A toSheaf/`AffineSerreVanishing`; Lane B tilde-exactness/`TildeExactness`).
- **Lanes that ran**: **1** — only the TildeExactness prover session started (see process note below).
- **Decls added**: +3 axiom-clean (all in the NEW file `TildeExactness.lean`); 0 new sorries.
- `archon dag-query`: **gaps = 0**, **unmatched = 4** (1 pre-existing dead `CechAcyclic.affine` +
  3 new TildeExactness helpers).

## Targets

### Lane B — `tildePreservesFiniteLimits` (01I8 Route-P step P3) — PARTIAL, honest
New file `AlgebraicJacobian/Cohomology/TildeExactness.lean`. The named target
`AlgebraicGeometry.tildePreservesFiniteLimits` (kernel/finite-limit-preservation of
`~ : ModuleCat R ⥤ (Spec R).Modules`) was **NOT added** — the prover stopped without a sorry and
delivered three genuine supporting theorems:

1. **`tilde_preservesFiniteColimits := inferInstance`** (L73) — right-exact half. `~` is a left
   adjoint (`tilde.adjunction`), so `PreservesFiniteColimits` resolves automatically.
2. **`tilde_toStalk_map_injective`** (L83) — flatness core, in the only publicly-nameable form:
   `IsLocalizedModule.map_injective` applied to the two public
   `IsLocalizedModule (tilde.toStalk · x).hom` instances ⟹ the localized stalk map of an injective
   `R`-module map is injective.
3. **`tilde_preservesFiniteLimits_of_preservesKernels`** (L95) — reduction wrapper:
   `Functor.preservesFiniteLimits_of_preservesKernels` discharges every ambient typeclass hyp for
   `tilde.functor R`, isolating the single remaining obligation as
   `∀ f, PreservesLimit (parallelPair f 0) (tilde.functor R)`.

**Abandoned attempt (not in final file):** the ModuleCat-valued stalk route to mono-preservation
(`mono_of_mono_map` + `mono_of_stalk_mono`) — DEAD because `StructureSheaf.toStalkₗ'`, `stalkIsoₗ`,
`stalkToLocalizationₗ`, `structurePresheafInModuleCat` are **module-private** in Mathlib (`#check`
→ "Unknown identifier"), so `IsLocalizedModule.map` cannot be applied against them.

**Remaining work = ONE thing** (corrected from the prover's own write-up — see audit below): build
`(tilde.functor R).PreservesMonomorphisms` / the per-`f` `PreservesLimit (parallelPair f 0)` via the
**Ab-valued** stalk route (`Scheme.Modules.toPresheaf` faithful/reflects-isos/preserves-limits +
`app_injective_of_stalkFunctor_map_injective` + germ-naturality transport via
`stalkFunctor_map_germ` and a ⊤-section naturality matching `tilde.toOpen` +
`tilde_toStalk_map_injective`), ~100–200 LOC. Then assemble via
`tilde_preservesFiniteLimits_of_preservesKernels`.

### Lane A — toSheaf cover-system (`AffineSerreVanishing.lean`) — NOT STARTED this iter
The plan dispatched two parallel lanes, but **only one prover session ran**. `provers-combined.jsonl`
contains a single `session_start` (TildeExactness); `AffineSerreVanishing.lean` is byte-unchanged
since iter-032 (mtime 02:27). The lane was blueprint-gate-cleared (`lem:toSheaf_preservesFiniteColimits`
added + `analogies/tosheaf-epi.md` recipe), so this is a **process/dispatch shortfall, not a math
block**. Re-dispatch unchanged next iter.

## Audit findings (subagents this iter)
- **lean-vs-blueprint-checker `tilde-iter033`: CLEAN** (0 red flags). All 3 helpers genuine and
  axiom-clean; `tilde_preservesFiniteLimits_of_preservesKernels` non-vacuous (`H` consumed by TC
  synthesis); named-target absence honestly documented; blueprint `% NOTE` at L4241 carries no false
  `\leanok`. Report: `task_results/lean-vs-blueprint-checker-tilde-iter033.md`.
- **lean-auditor `iter033`: 0 must-fix / 1 major / 1 minor.**
  - **MAJOR (HIGH in recommendations):** the file's module docstring "obstruction 2" (claims the
    categorical glue "right-exact + preserves-monos ⟹ left-exact" is absent from Mathlib and must be
    built) is **directly contradicted by the code in the same file** — `tilde_preservesFiniteLimits_of_preservesKernels`
    already uses the Mathlib kernel-route lemma `Functor.preservesFiniteLimits_of_preservesKernels`.
    Only **one** gap remains (the stalk-map mono identification, "obstruction 1"). The docstring would
    mislead the planner into over-estimating remaining work. Lives in a `.lean` file the review agent
    cannot edit → flagged for the planner to have the next prover/refactor correct it.
  - **MINOR:** `tilde_preservesFiniteLimits_of_preservesKernels` binds `(H : …)` as a regular arg that
    acts as a local instance; should be `[H : …]` for clarity (works either way).
  - Report: `task_results/lean-auditor-iter033.md`.

## Blueprint markers updated (manual)
- (none) — no `\mathlibok` (the 3 new decls are project theorems wrapping Mathlib instances, not
  bare re-export aliases), no `\lean{}` rename (prover used the planner's hinted names), no stale
  `\notready`. The `lem:tilde_preserves_kernels` block correctly remains without `\leanok` (named
  target absent) and already carries an accurate `% NOTE` (L4241); the `lem:toSheaf_preservesFiniteColimits`
  block likewise correctly lacks `\leanok` (Lane A never ran). `sync_leanok` (iter=33, sha 49b3df2)
  removed 2 stale `\leanok` — consistent with both named targets being absent.

## Blueprint doctor
Clean — no orphan chapters, no broken `\ref`/`\uses`, no new `axiom` decls.

## Coverage debt (unmatched)
3 new TildeExactness helpers (`tilde_preservesFiniteColimits`, `tilde_toStalk_map_injective`,
`tilde_preservesFiniteLimits_of_preservesKernels`) + the pre-existing dead `CechAcyclic.affine`.
Listed in `recommendations.md` for the planner to blueprint.

## Key findings / notes
- Clean stop on real mathematics again: Lane B delivered its provable leaves (right-exactness,
  flatness core, kernel-route reduction) and stopped on the genuine Ab-stalk-transport build, no
  sorry, no weakening.
- The 01I8 P3 remaining gap is now **sharper than the prover's own write-up**: it is a single
  ~100–200 LOC Ab-stalk germ-naturality transport, NOT two obstructions. (lean-auditor correction.)
- A planned lane silently did not execute — surfaced for the planner.
