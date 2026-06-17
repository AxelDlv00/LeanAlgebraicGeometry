# Session 250 (iter-250) — review summary

## Metadata
- **Session / iter:** 250 (prover model: opus, mode `prove`)
- **File sorry count (TensorObjSubstrate.lean): 2 → 1.** Project-wide term-level sorries: ~81.
- **Headline:** **D2′ CLOSED, axiom-clean.** The D2′ `(∗∗)` unit-square residual — the canonical
  critical-path obstacle that held the route flat for iters 239–249 — is eliminated.
- **Lane:** TS only (`Picard/TensorObjSubstrate.lean`). No RPF lane (converged, D4′-gated).

## Target: `pullbackTensorMap_unit_isIso` (D2′ closer, `lem:pullback_tensor_iso_unit`) — SOLVED

Closes automatically once `pullbackEtaUnitSquare` is sorry-free:
```
isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta f
  (isIso_sheafifyEta_of_unitSquare f (pullbackEtaUnitSquare f))
```
**Review-verified first-hand:** `lean_verify` → axioms `{propext, Classical.choice, Quot.sound}`,
NO `sorryAx`. Full-file diagnostics → 0 errors. (The "opaque" warning at L478 is a prose comment.)

## Target: `pullbackEtaUnitSquare` (`lem:eta_bridge_unit_square`) — SOLVED (the real work)

After the abstract mate-calculus telescope (steps 1–6, closed in iters 248–249) and
`refine Eq.trans ?_ hrhs.symm`, the concrete `(∗∗)` presheaf identity was closed:

- **Attempt 1 (DEAD END):** strip the two `restrictScalars (𝟙)` wrappers via `show …`/`rfl` (the
  analogist eps250 headline idiom — "restrictScalars(𝟙) absorbed defeq cheaply").
  `lean_error: (deterministic) timeout at whnf, maximum number of heartbeats (6400000)`. The "cheap
  defeq" premise is FALSE at this term scale — whnf over sheafification-laden composites blows up.
- **Attempt 2 (KEY):** new helper `restrictScalarsId_map : (restrictScalars (𝟙 R)).map g = g := rfl`
  stated propositionally over abstract `g` (essentially free). `rw [restrictScalarsId_map,
  restrictScalarsId_map]` strips both wrappers syntactically → clean presheaf goal
  `(u ≫ pf₁.map toSheafify_Y) ≫ pf₂.map ((a_Y.map (η F)).val ≫ sheafifyUnitIso.hom.val)
  = (unitToPushforwardObjUnit φ).val`.
- **Attempt 3 (close):** `erw [Category.assoc, ← Functor.map_comp, pullbackSheafifyUnitEtaTriangle f,
  presheafUnit_comp_map_eta f, epsilonPresheafToSheafUnit f]` → no goals. **`erw` is load-bearing:**
  `pf₁ = pushforward (Hom.toRingCatSheafHom f).hom` (from `leftAdjointUniqUnitEta`) and
  `pf₂ = pushforward φ.hom` (the `set`-local `φ`) are defeq but differently spelled; `rw`/`simp only
  [Category.assoc]` fail to match at the connecting object, `rw [hφ]` → dependent-motive error,
  `simp only [hφ]` → no progress, and a `show` unifying `φ` blows the budget. `erw`'s keyed-defeq
  reassociation fits within `set_option maxHeartbeats 3200000`.

## Feeder lemmas authored this iter — all SOLVED, axiom-clean

- **`restrictScalarsId_map`** (`:= rfl`): reusable syntactic strip; see Attempt 2.
- **`epsilonPresheafToSheafUnit`** (step 7 / substep iii): `ε(pushforward φ') =
  (unitToPushforwardObjUnit φ).val`, proved sectionwise (`hom_ext → hom_ext → ext r`) via
  `erw [unitToPushforwardObjUnit_val_app_apply, ModuleCat.restrictScalars_η]; rfl`. Needs a `letI`
  supplying the `CommRing` on the `(restrictScalars f).obj 𝟙_` carrier (synthInstance diamond) and
  `set_option backward.isDefEq.respectTransparency false`.
- **`pullbackSheafifyUnitEtaTriangle`** (substep ii): `toSheafify_Y ≫ (a_Y.map (η F)).val ≫
  sheafifyUnitIso.hom.val = η F`. Needs `letI : (pushforward φ').IsRightAdjoint` for the naturality
  `erw`; closes by reading `η F` off the goal (`refine Eq.trans ?_ (Category.comp_id _); congr 1`)
  to avoid `OplaxMonoidal` re-synthesis. `set_option maxHeartbeats 1600000`.

## Untouched: `exists_tensorObj_inverse` (L705) — out of scope (guard-railed ⊗-inverse lane)

Not on the D2′→D3′→D4′ critical path. Two bridges remain (see `informal/exists_tensorObj_inverse.md`).

## Key findings / patterns
- See PROJECT_STATUS.md Knowledge Base (iter-250 additions) for the reusable patterns:
  propositional `restrictScalarsId_map` strip, load-bearing `erw` merge, the catastrophic-whnf dead
  end, the `letI` CommRing carrier fix, and the read-`η F`-off-goal triangle close.

## Blueprint markers updated (manual)
- None. The three closed D2′ proof blocks (`lem:eta_bridge_unit_square`,
  `lem:pullback_tensor_iso_unit`, `lem:epsilon_presheaf_to_sheaf_unit`) get `\leanok` via the
  deterministic `sync_leanok` (which ran +28/−0 this iter). No `\mathlibok` is warranted (none are
  Mathlib re-exports), no `\lean{...}` rename occurred, no `\notready` was present to strip.

## Subagent reports (full content: linked, not inlined)
- `task_results/lean-vs-blueprint-checker-ts250.md`: 0 must-fix; all 4 pinned decls faithful;
  1 MINOR stale-prose note (D2′ overview ~L2670–2680 names obsolete `δ_comp_η_tensorHom` route).
- `task_results/lean-auditor-ts250.md`: see recommendations.md for findings.

## Recommendations (detail in recommendations.md)
1. **Advance Lane TS to D3′** (δ-vs-open-immersion base-change square) — D2′ is no longer a gate.
2. **Plan must reflow the 4 corrupted `\uses{}` lists** (the recurring `\leanok`-in-`\uses{}` sync
   defect re-fired on 4 decls); root fix is user-side in `sync_leanok`.
3. **Blueprint-writer pass** on the stale D2′ overview paragraph when D3′'s chapter is touched.
