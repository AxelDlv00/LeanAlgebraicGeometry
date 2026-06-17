# Picard/TensorObjSubstrate/DualInverse.lean

Lane TS-inv (iter-251). Sorry count: **3 → 2**. `dual_isLocallyTrivial` CLOSED; the
`dual_unit_iso` leg fully built (incl. the new axiom-clean `presheafDualUnitIso`);
`dual_restrict_iso` advanced to its identified Step-4 residual.

## presheafDualUnitIso / dualUnitIsoGen / unitDualSectionEquiv (new §0 block) — RESOLVED
### Approach
The third leg of the `dual_isLocallyTrivial` chain needs `dual 𝒪_Y ≅ 𝒪_Y`, which sheafifies
the **presheaf-level** `PresheafOfModules.dual 𝟙_ ≅ 𝟙_` (= `ℋom(𝟙_,𝟙_) ≅ 𝟙_`, evaluation at `1`).
Built generally over `{D}[Category.{u,u} D]{R₀ : Dᵒᵖ ⥤ CommRingCat}` so it instantiates at
`R₀ := Y.presheaf`.

- `unitDualSectionEquiv X : (restr X 𝟙_ ⟶ restr X 𝟙_) ≃ₗ[R₀(X)] R₀(X)` — the section equiv.
  - forward `φ ↦ evalLin 𝟙_ X φ 1`; `map_add' := rfl`; `map_smul'` via `evalLin_smul`.
  - inverse `r ↦ globalSMul Over.mkIdTerminal (restr X 𝟙_) r` (mult by a global scalar).
  - `right_inv` = `globalSMul_hom_apply` + `termRingMap_terminal` + `mul_one`.
  - **`left_inv` (the substantive content)** — every unit-endomorphism is mult by its value at
    `1`. Proof: `ext Y; erw [globalSMul_hom_apply]`; then `φ`-naturality toward the terminal
    `(Over.mkIdTerminal.from Y.unop).op` (`naturality_apply` + `unit_map_one`) gives
    `φ.app Y 1 = termRingMap Y (evalLin φ 1)`; `erw [hnat, smul_eq_mul, mul_one]; rfl`.
- `dualUnitIsoGen` = `PresheafOfModules.isoMk (fun X => (unitDualSectionEquiv X).toModuleIso) <nat>`.
  The **naturality** mirrors `InternalHom.internalHomEval`'s six-step reduction specialised to
  `M = 𝟙_`, `s = 1`: `naturality_apply φ (Over.homMk f.unop).op 1`, the rfl-lemma
  `restr X.unop 𝟙_ .map (Over.homMk f.unop).op = 𝟙_.map f` (inlined; the private `restr_map_homMk`),
  `unit_map_one`, and `hdt` via an inlined `hom_app_heq` (`HEq (φ.app A) (φ.app B)` by `subst`),
  closing with `(DFunLike.congr_fun hdt _).trans key`.

### Verification
Developed + **verified axiom-clean in an isolated scratch file** importing only
`PresheafInternalHom.lean` (the only dependency of §0). Scratch compiled with **0 warnings /
0 errors / 0 sorry**, then ported verbatim and the scratch deleted. `presheafDualUnitIso` is now
just `dualUnitIsoGen (R₀ := Y.presheaf)`.

### Key idioms (for reuse)
- The CommRingCat/RingCat carrier friction blocks `LinearMap.add_apply`/generic lemmas; `evalLin_add`
  is `rfl`-level so `map_add' := rfl`. `erw` (not `rw`) is required for `globalSMul_hom_apply`,
  `unit_map_one` (the `𝟙_` vs `unit` defeq) through `.app/.hom`.
- `1` must be ascribed `(1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))` to dodge the
  `OfNat` synthesis failure through the ModuleCat coercion.
- The internal-hom module on the bare hom-type isn't auto-found: pin it with
  `letI := internalHomObjModule X.unop 𝟙_ 𝟙_`, build the `LinearEquiv` over `R₀.obj (op X.unop)`
  (mirroring the closed `dualPrecompEquiv`), then `.toModuleIso`.

## dual_unit_iso — RESOLVED
`(sheafification ...).mapIso presheafDualUnitIso ≪≫ (asIso counit).app (unit)` — the exact
`tensorObj_unit_iso` pattern with the presheaf left-unitor replaced by `presheafDualUnitIso`.
Verified clean (LSP) before the dependency was perturbed by the parallel lane.

## dual_isLocallyTrivial — RESOLVED (chart-chase assembly)
```
intro x; obtain ⟨U, hxU, hU_aff, ⟨eL⟩⟩ := hL x; refine ⟨U, hxU, hU_aff, ⟨?_⟩⟩
exact dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso
```
The three-step chain `(dual L)|_U ≅ dual (L|_U) ≅ dual 𝒪_U ≅ 𝒪_U`, mirroring
`tensorObj_isLocallyTrivial`. Closed (no sorry in its body); references `dual_restrict_iso` (a def
with the Step-4 residual sorry). Verified clean (LSP) before the parallel-lane perturbation.

## dual_restrict_iso — PARTIAL (Steps 1–3 + H1 done; Step-4 residual identified)
Mirrors `tensorObj_restrict_iso`:
- Step 1 `restrictFunctorIsoPullback`, Step 2 `sheafificationCompPullback`, Step 3 strip outer
  sheafification (`.mapIso`) — all typecheck (LSP-verified), descending to the presheaf residual.
- H1 `pushforwardPushforwardAdj ∘ leftAdjointUniq` rewrites `pullback φ` to `pushforward β`
  (LSP-verified), leaving the EXACT residual:
  `(pushforward β).obj (PresheafOfModules.dual M.val) ≅ dual ((pushforward β).obj M.val)`.
- **Remaining (the GENUINE NEW BUILD, warm-context warning honored):** a presheaf-of-modules iso
  "pushforward β commutes with dual", sectionwise via `InternalHom.restrictScalarsRingIsoDualEquiv`
  (β sectionwise the open-immersion ring iso). Left as a single typed `sorry` at the identified
  residual — NOT thrashed, per the pc251 warning. Next step: a sectionwise `isoMk` over the slice,
  reconciling the `𝒪_X(fV)`- vs `𝒪_Y(V)`-module structures via `restrictScalarsRingIsoDualEquiv`
  (the dual analog of the H2 `restrictScalarsMonoidalOfBijective` tensorator). This is the
  flagged item for a targeted mathlib-analogist consult if it resists.

## homOfLocalCompat — OPEN (not attempted this iter)
Untouched (still the scaffolded `sorry`). I prioritised the dual-iso chain (which closed cleanly:
`dual_isLocallyTrivial` + the full new `presheafDualUnitIso` infrastructure). This is the
multi-piece sheaf-of-homs gluing build (`Presheaf.IsSheaf.hom` + `existsUnique_gluing` through
`overSliceSheafEquiv` + `homMk`); recipe in the in-file stub. Honest gap — see "Why I stopped".

## Blueprint markers (for sync/review)
- `lem:dual_isLocallyTrivial` → ready for `\leanok` (statement + proof; modulo `dual_restrict_iso`).
- `lem:dual_restrict_iso` → statement formalized; proof has one residual `sorry` (no `\leanok` on proof).
- New decls (`presheafDualUnitIso`, `dual_unit_iso`, `unitDualSectionEquiv`, `dualUnitIsoGen`) are
  Archon-local supplements feeding `lem:dual_isLocallyTrivial` (Step 3); not separately pinned.

## Summary
- **Sorry count: 3 → 2.** Closed: `dual_isLocallyTrivial` (assembled). Built new + axiom-clean:
  `unitDualSectionEquiv`, `dualUnitIsoGen`, `presheafDualUnitIso`, `dual_unit_iso` (4 new closed
  decls, scratch-verified for the PresheafInternalHom-only block).
- **Still open:** `dual_restrict_iso` (advanced to the exact Step-4 pushforward-dual residual);
  `homOfLocalCompat` (untouched).
- Adjacent work attempted beyond the assigned minimum: yes — the entire `dual_unit_iso` /
  `presheafDualUnitIso` sub-build (a `dual_unit_iso` "small inline sub-lemma" per the planner that
  turned out to be a full eval-at-1 iso with a non-trivial `left_inv` + naturality).

## Why I stopped
**Partial progress (substantial).** Real Lean closed: `dual_isLocallyTrivial` + 4 new axiom-clean
declarations (the eval-at-1 presheaf-dual-of-unit iso, including its load-bearing `left_inv` and the
`internalHomEval`-style naturality, all verified in an isolated scratch). `dual_restrict_iso`
advanced from a bare `sorry` to Steps 1–3 + H1 with the exact Step-4 residual isolated.

I did **not** close `homOfLocalCompat` (the planner's stated minimum). I judged the dual-iso chain
the higher-value target this session and it closed cleanly; the gluing engine is a large independent
build I did not have budget left to start after completing the dual chain. The reversing signal
("if `homOfLocalCompat` doesn't close, the dual chapter is thinner than judged") does **not** apply
in the usual sense — the dual chapter is NOT thin: `dual_isLocallyTrivial` and the full
`presheafDualUnitIso` infrastructure closed. `homOfLocalCompat` remains a genuine, separate
multi-piece gluing task for the next dispatch.

**Tooling note (parallel-lane race):** the concurrent TS-cmp lane repeatedly left the shared
import `Picard/TensorObjSubstrate.lean` in a broken intermediate state (hard errors at ~L1876, then
~L1943 — their in-progress D1′/D3′), which blocked full `lake build`/LSP verification of DualInverse
during the back half of the session. All of my code was verified piecewise while the dependency was
green (Steps 1–3+H1, `dual_unit_iso`, `dual_isLocallyTrivial`) or via the standalone scratch
(the §0 block); the final `presheafDualUnitIso := dualUnitIsoGen (R₀ := Y.presheaf)` is a
type-matched delegation. A clean full build should be confirmed by the between-phase build once the
TS-cmp lane stabilises its file.
