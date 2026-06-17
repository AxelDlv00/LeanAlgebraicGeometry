# Session 42 (iter-042) — Review Summary

## Metadata
- **Iteration:** 042 — single prover lane on `AlgebraicJacobian/Picard/QuotScheme.lean` [mathlib-build].
- **Active sorry count:** QuotScheme 4 → 4 (the four frozen iter-176 protected scaffold stubs at lines
  126/165/201/228, untouched, out of scope). **Zero new sorries.**
- **Build:** `lake build AlgebraicJacobian.Picard.QuotScheme` → `Build completed successfully (8317 jobs)`
  (style/long-line/heartbeat-comment warnings only).
- **Net:** +5 axiom-clean non-private declarations (`{propext, Classical.choice, Quot.sound}` — two
  independently re-verified this review phase: G1-core + gap2-core).
- **sync_leanok** (iter 42, sha `a55fdae`): **+5 `\leanok`, 0 removed** (Picard_QuotScheme only).
- **leandag:** `gaps=0`, `frontier=7`, `unmatched=4` (the 4 new helper decls — coverage debt, listed below).
- **blueprint-doctor:** 0 structural findings.

## Targets attempted

### (1) G1-core — `isLocalizedModule_basicOpen_of_isQuasicoherent` (line 2433) — SOLVED
Planner objective (1). Exactly the planned one-liner:
```lean
haveI := isIso_fromTildeΓ_of_isQuasicoherent M
isLocalizedModule_restrict_of_isIso_fromTildeΓ M f
```
Both ingredients were DONE/axiom-clean from the iter-041 gap1 close. This is the clean named form of
`lem:qcoh_affine_section_localization` (the affine `X = Spec R`, `U = ⊤` instance of gap2). Blueprint
`\lean{...}` already pinned it; `\leanok` synced.

**Redundancy flagged (lean-auditor major):** this decl has the *identical* signature to the pre-existing
`isLocalizedModule_basicOpen_descent` (line 2396) — both
`(M : (Spec R).Modules) [M.IsQuasicoherent] (f : R) : IsLocalizedModule (powers f) ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE le_top).op).hom`.
The descent routes through the cover; G1-core routes through `isIso_fromTildeΓ_of_isQuasicoherent` (which is
itself built *from* the descent). Two public names for one fact — see recommendations §2.

### (2) gap2 — `isLocalizedModule_basicOpen` (`lem:qcoh_section_localization_basicOpen`) — PARTIAL
Planner objective (2). The hard ~80% landed as three supporting decls; the consumer-facing gap2 itself is
left **ABSENT** (no sorry, per mathlib-build discipline) pending two precisely-scoped pieces.

Supporting decls landed (all axiom-clean):
- **`restrictₗ`** (2251) — `Γ(M,U) →ₗ[Γ(X,U)] Γ(M,V)` for `i : V ⟶ U`, codomain given the `Γ(X,U)`-module
  structure `Module.compHom _ (X.presheaf.map i.op).hom`; `map_smul' = Scheme.Modules.map_smul`.
- **`restrictBasicOpenₗ`** (2267) — the scalar-tower form `Γ(M,U) →ₗ[Γ(X,U)] Γ(M, X.basicOpen f)`, taking
  `[Module Γ(X,U) Γ(M,X.basicOpen f)] [IsScalarTower …]` as hypotheses (consumer-supplied, matching
  `Module.annihilator_isLocalizedModule_eq_map`'s instance shape). **Two restriction maps are forced**:
  `Algebra Γ(X,U) Γ(X,V)` exists only for `V = X.basicOpen f`, not for general nested `j ''ᵁ` opens.
- **`fromSpec_image_top_section_coherence`** (2288) — **the gap2 crux** (the "sole genuinely new piece" the
  blueprint flagged), PROVEN. Statement: `X.presheaf.map (eqToHom eT.symm).op = (hU.fromSpec.appIso ⊤).hom ≫
  (ΓSpecIso Γ(X,U)).hom`; equivalently `ρ (σ f) = f`. The proof (`← cancel_epi`; `appIso_hom'`+`appLE`;
  `reassoc_of% fromSpec.naturality`; `fromSpec_app_self`; `eqToHom` folding via `← eqToHom_map` with side
  goal closed by `rw [eT, fromSpec_preimage_self]`; `Subsingleton.elim _ (𝟙 (op ⊤))`; `map_id`;
  `Iso.inv_hom_id`) took ~25 iterative rewrite attempts (pattern-not-found / eqToHom mismatches) before
  landing — see milestones attempt 2.
- **`section_localization_hfr_aux_general`** (2321) — **gap2-core transport**, the verbatim port of
  iter-041's `section_localization_hfr_aux` to a *general* ambient scheme `X` (localization ring is the
  LOCAL `A = Γ(X, j ''ᵁ ⊤)`). Takes the P1 datum `hP1 : IsIso (fromTildeΓ ((pullback j).obj M))` as a
  hypothesis. **Because base and target rings coincide (`R = A`), bridge (II) `restrictScalars` is not
  needed** (the original aux needed it because `R ≠ Γ(Spec R,…)`).

**Why gap2 itself stopped — two remaining pieces (both precisely scoped):**
- **Piece A (NEW Mathlib-absent gap, ~moderate):** `((pullback hU.fromSpec).obj M).IsQuasicoherent` for
  `[M.IsQuasicoherent]`. Lean error: `failed to synthesize SheafOfModules.IsQuasicoherent ((pullback j).obj
  M)`. Mathlib has NO `pullback`-preserves-`IsQuasicoherent` instance (only `tilde` is QC). Route: reduce
  `(pullback hU.fromSpec).obj M = (pullback isoSpec.inv).obj ((pullback U.ι).obj M)` to "restriction of QC
  along an open immersion is QC", building a `QuasicoherentData` for `(pullback U.ι).obj M` by refining
  `M`'s cover `q` to `{U ⊓ q.X i}` and pulling slice presentations back (`Presentation.map` +
  `pullbackObjFreeIso`).
- **Piece B (mechanical, ~60–100 lines):** the `eqToHom` bridge from `section_localization_hfr_aux_general`
  to `restrictBasicOpenₗ M f` via `isLocalizedModule_of_ringEquiv_semilinear`. Its only non-trivial input,
  `ρ F = f`, **is exactly the proven crux `fromSpec_image_top_section_coherence`** composed.

## Key findings / patterns
- **`show … from` ascription is load-bearing for `IsLocalizedModule (powers f) (restrictₗ M i)`**: without
  both the in-scope `letI : Module … := Module.compHom …` AND `show Γ(M,U) →ₗ[Γ(X,U)] Γ(M,V) from restrictₗ
  M i`, the domain `Module Γ(X,U) Γ(M,U)` fails to synthesize (elaboration order: `M`/`M'` are metavars when
  `IsLocalizedModule` triggers instance search). Recorded as a reusable pattern.
- **`eqToHom`-into-`presheaf.map` folding (`← eqToHom_map`)** is the move that made the gap2 crux tractable:
  collapse a stray Spec-presheaf `eqToHom` back into a `presheaf.map`, merge with the leftover `homOfLE.op`
  via `← map_comp`, then the merged `op ⊤ ⟶ op ⊤` morphism is forced by `Subsingleton.elim`.
- **Same-ring shortcut:** porting a `Spec R`-anchored localization-transport to a general scheme can DROP the
  `restrictScalars` bridge when the localization ring is taken locally (`Γ(X, j ''ᵁ ⊤)`), because base and
  target rings then coincide.

## Subagent reports (this review phase)
- **lean-auditor `quot-iter042`** (0 critical / 1 major / 5 minor): all 5 decls honest + axiom-clean; the
  `letI`/`show`-from idiom certified sound (no defeq weakening). Major = the G1-core ≡ descent duplicate
  signature (recommendations §2). Minors = stale line-650 comment, 4 currently-unconsumed forward helpers.
  Report: `.archon/task_results/lean-auditor-quot-iter042.md`.
- **lean-vs-blueprint-checker `quot-iter042`** (0 must-fix / 2 major): G1-core `\lean{...}` pin matches
  exactly ✓, gap2 correctly absent with `% NOTE` ✓. Major (blueprint-side, iter-043 prep): the
  `lem:qcoh_section_localization_basicOpen` sketch (a) never mentions the `eqToHom` bridge crux and (b) still
  calls the transport "the sole new piece" though `section_localization_hfr_aux_general` already exists →
  duplication risk for the iter-043 prover. Major (carry-forward, pre-existing): `Grassmannian.representable`
  Lean weaker than blueprint prose. Report: `.archon/task_results/lean-vs-blueprint-checker-quot-iter042.md`.

## Blueprint markers updated (manual)
- None this iter. `\leanok` is `sync_leanok`'s domain (+5 added deterministically). No `\mathlibok` (all 5 new
  decls are project-local, not Mathlib-backed). No `\lean{...}` rename (G1-core matches its existing pin; the
  4 helpers have no blocks yet). No stale `\notready` found on any landed block.

## Recommendations for next session
See `recommendations.md`. Headline: iter-043 builds gap2 Piece A (QC-under-pullback) then Piece B (eqToHom
bridge); planner updates the gap2 blueprint sketch (name the crux, drop "sole new piece"); planner decides
the G1-core / descent dedup; and per the iter-042 plan's HARD constraint, **iter-043 MUST dispatch the FBC
prover** (affine tilde-transport) — a second consecutive no-prover FBC iter would be CHURNING-by-avoidance.
