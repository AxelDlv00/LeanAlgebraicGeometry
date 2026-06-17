# Recommendations — after iter-025 (for the next plan iter)

## HIGH — investigate / re-run sync_leanok (spurious marker loss)
`sync_leanok-state.json` iter-025 = **removed 6, added 0** on
`Cohomology_CechHigherDirectImage.tex`. Four axiom-clean, compiling blocks now lack `\leanok`:
- `lem:injective_cech_acyclic` (this iter's target — never got `\leanok`),
- `lem:ses_cech_h1` (had `\leanok` after iter-024 — it was REMOVED),
- plus 2 more CechBridge-/FreePresheafComplex-backed blocks (per the "removed 6" delta and
  lean-vs-blueprint-checker's "4 axiom-clean blocks" finding).

Ground truth (review-verified): `lean_verify` → `{propext, Classical.choice, Quot.sound}` for
both `injective_cech_acyclic` and `ses_cech_h1`; `lake env lean CechBridge.lean → EXIT 0`.
The proofs are sound — this is a sync mis-verdict, most likely a **build timeout** in the sync
window (CechBridge's heaviest decl requires `maxHeartbeats 2000000`; a lower sync budget reads
it as non-compiling and cascades the strip). **Action**: have the next iter re-run sync_leanok
(or confirm its heartbeat/timeout budget covers `maxHeartbeats 2000000` files) so the markers
are restored. The review agent cannot touch `\leanok`. This is bookkeeping, not a math regression.

## HIGH — next frontier: `def:absolute_cohomology`, then the 01EO→02KG chain
The P3b Čech bridge is now COMPLETE (`injective_cech_acyclic`, `ses_cech_h1`,
`cechFreeComplex_quasiIso` all landed). `archon dag-query gaps` = 0 (no ∞ holes); the frontier
is 3 nodes:
- `def:absolute_cohomology` (effort 2878, deps 6, used-by 2) — the Ext-based absolute cohomology
  definition; the strategic next step toward re-enabling the frozen P5b.
- `lem:cech_free_eval_prepend_homotopy` (effort 739) — engine→eval transport corollary.
- `lem:cech_acyclic_affine` (carries the blueprint-authorized superseded `[sorry]` on
  `CechAcyclic.affine`; the section form `sectionCech_affine_vanishing` is already proved).

Sequence the absolute-cohomology + 01EO (`cech_to_cohomology_on_basis`) + 02KG work that
re-enables the frozen P5b `cech_computes_higherDirectImage` (`CechHigherDirectImage.lean:679`).
Check `analogies/absolute-cohomology.md` (present in the tree) for the planned shape.

## MEDIUM — stale `.lean` comments in CechBridge.lean (lean-auditor iter-025, 3 major)
Review cannot edit `.lean`. Queue for the **next prover that opens CechBridge.lean**:
- Lines 77–119: planner-strategy comment block is factually wrong about the shipped code —
  it prescribes `isoOfComponents` as the assembly combinator, but the implementation uses
  `alternatingCofaceMapComplex.mapIso` of a cosimplicial iso (line 269). Fix or delete the block.
- Line 273: section header still says "gated on Lane-1's `cechFreeComplex_quasiIso`" —
  `injective_cech_acyclic` is now proved; drop the gating language.
- Line 357: `sectionCechComplexMapOpIso` docstring "once Lane 1 provides
  `QuasiIso (cechFreeComplexAug 𝒰)`" — Lane 1 has landed; update.
- (Minor) Line 637: add the missing inline comment explaining `set_option maxHeartbeats 1600000`
  on `ses_cech_h1`, matching the documented bump at line 851.
Full report: `.archon/task_results/lean-auditor-iter025.md`.

## Reusable proof patterns (from this iter's landing)
- **Op-transport quasi-iso assembly**: to vanish homology of complex `B`, build a `QuasiIso`
  `Θ : A → B` and show `A` has zero homology. `QuasiIso` of an opped morphism is automatic from
  `[QuasiIso f]`; `quasiIso ∘ iso` stays `QuasiIso` via `inferInstance`; transfer with
  `(isZero).of_iso (asIso (homologyMap Θ i)).symm` (`IsIso (homologyMap Θ i)` from
  `instIsIsoHomologyMapOfQuasiIsoAt`).
- **`single₀` zero degrees**: `ChainComplex.single₀` is reducibly
  `HomologicalComplex.single _ (down ℕ) 0`; use `HomologicalComplex.isZero_single_obj_X`
  with `Nat.succ_ne_zero` for the `n+1` degrees. Avoid `single₀_obj_X_succ`/`OfNat C 0` paths.
- **Legitimate heartbeat bumps**: nested `opFunctor`/`mapHomologicalComplex`/`(down ℕ).symm`
  coercion stacks blow the default 200000 heartbeat budget on defeq; a documented
  `set_option maxHeartbeats 2000000 in` is the correct fix, not a smell (lean-auditor-confirmed).

## Do NOT re-assign
- `injective_cech_acyclic`, `ses_cech_h1`, `cechFreeComplex_quasiIso` — DONE, axiom-clean. (If
  they appear "unproved" in the DAG, that is the sync_leanok `\leanok` gap above, not real work.)
- `CechAcyclic.affine` (line 110) and the frozen P5b sorry (`CechHigherDirectImage.lean:679`):
  intentional — do not "fix". P5b unfreezes only via the 02KG chain.
