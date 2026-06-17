# AlgebraicJacobian/Cotangent/GrpObj.lean

## Iter-142 prover lane: piece (i.b) Step 2 sub-sorry closure (BUNDLED 3 sub-sorries)

**Result: PARTIAL — 1 of 3 sub-sorries closed substantively (d_map at L643);
2 of 3 remain (d_app at L624 with extended factoring-witness scaffold;
IsIso at L689 narrowed structurally per iter-140; both with refined
follow-on recipes captured below).**

Sorry count at iter-142 close on this file: **3 decls / 3 inline**
(was 3 decls / 4 inline at iter-142 entry). Net strict closure: −1 inline
sorry. File compiles cleanly (`lake env lean` via LSP diagnostic_messages
returns success: true with exactly 3 `declaration uses sorry` warnings at
L573 + L697 + L833). No new axioms.

**Pre-committed acceptance matrix verdict: PARTIAL arm** (0 or 1 sub-sorries
closed; per PROGRESS.md L142). Specifically: 1 of 3 closed substantively
(d_map). d_app + IsIso retain their iter-140 narrowed structural shape
plus iter-142 enhancements (more explicit `change` skeleton for d_app).

---

## d_map at L643 — CLOSED ✓ (substantive iter-142 close)

### Attempt: ψ-naturality + relativeDifferentials'_map_d via fully-explicit `change`
- **Approach**: per `analogies/d-app-d-map-recipe-shape.md` Decision 4
  (3-step ALIGN_WITH_MATHLIB chase). Stitched together
  `NatTrans.naturality_apply` for ψ on the LHS with
  `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d`
  on the RHS.
- **Result**: RESOLVED.
- **Key insight**: The iter-141 blueprint warned that `change KD.d _ = _`
  with a placeholder RHS triggers a deterministic `whnf` timeout at
  `maxHeartbeats=200000` due to the `set_option backward.isDefEq.respectTransparency false`
  annotation on `pushforward₀` (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:37, 55`).
  **The fix**: write the `change` *fully explicitly* on both LHS and RHS
  (spelling out the `(pushforward ψ).obj LHS .map f` factor on the RHS).
  This avoids the `_` placeholder elaboration that would require `whnf`
  to descend into the opaque `pushforward₀`.
- **Second key insight**: A bare `rw [NatTrans.naturality_apply ψ.hom f x]`
  fails to match because the lemma produces an equation in
  `ConcreteCategory.hom`-form whereas the post-`change` goal carries
  `RingCat.Hom.hom`/`CommRingCat.Hom.hom`-form term shapes. **The fix**:
  package the naturality fact via `rw [show ψ.app Y .hom (G.left.presheaf.map f x) = ... from NatTrans.naturality_apply ...]`,
  forcing the rewrite pattern into the `.hom`-form that matches the goal.
- **Mathlib lemmas consumed**:
  - `NatTrans.naturality_apply` (`Mathlib.CategoryTheory.ConcreteCategory.Basic:221`).
  - `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d` (`Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf:201–207`).
  - Implicit: `PresheafOfModules.pushforward_obj_map_apply` (`Pushforward.lean:95–97`) — used by definitional equality, not invoked by name (the `.map f .hom` unfolding is `rfl` for `pushforward`).
- **LOC**: ~30 LOC body (closer to the low end of the iter-141 ~30–50 LOC
  envelope).

### Dead-end warnings (preserve for iter-143+ provers)
- **DO NOT** use `change KD.d _ = _` with a `_` RHS placeholder on any
  pushforward-transposed goal — deterministic `whnf` timeout, regardless
  of heartbeat budget. The opacity annotation is a guard, not a
  performance issue.
- **DO NOT** rely on `rw [NatTrans.naturality_apply ...]` to fire on
  goals that carry the post-`change` `RingCat.Hom.hom` form. Use the
  `rw [show ... from NatTrans.naturality_apply ...]` packaging instead
  to align the rewrite pattern.

---

## d_app at L624 — IN PROGRESS (extended skeleton landed; witness construction is the remaining gap)

### Attempt 1: `simp` / `aesop` / `cat_disch` / `apply ModuleCat.Derivation.d_map`
- **Approach**: try Mathlib defaults.
- **Result**: FAILED.
- **Why**: the goal `KD.d (ψ.app X (φ_G.app X a)) = 0` does NOT structurally
  match `KD.d (f x) = 0` for the standard algebra-map shape, because
  `ψ.app X ∘ φ_G.app X` is not literally `φ_LHS.app (snd⁻¹X)`; the
  factoring requires construction of a witness ring map
  `h : ((pullback G.hom.base).obj (Spec k).presheaf).obj X ⟶ ((pullback (fst G G).left.base).obj G.left.presheaf).obj (snd⁻¹X)`
  with `h ≫ φ_LHS.app (snd⁻¹X) = φ_G.app X ≫ ψ.app X`.

### Attempt 2: explicit `change` to expose the goal shape
- **Approach**: replace the iter-140 `change (CommRingCat.KaehlerDifferential.D _).d _ = 0`
  (which leaves placeholders) with a fully-explicit `change`
  (spelling out the `ψ.app X .hom (φ_G.app X .hom a)` argument).
- **Result**: PARTIAL (explicit `change` succeeds; the underlying
  factoring + `d_map` discharge remains `sorry`-bodied).
- **Landed in code** at L611–L618 (new `change` block) — the goal at the
  `sorry` is now in canonical form, making the iter-143+ closure recipe
  unambiguous.

### Closure recipe (carry to iter-143+)
1. **Categorical equality**:
   `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom` from `(fst G G).w` +
   `(snd G G).w` (both equal `(G ⊗ G).hom`).
2. **Lift to c-components** via `PresheafedSpace.comp_c_app`:
   `((fst).left ≫ G.hom).c.app X = G.hom.c.app X ≫ (fst).left.c.app (G.hom⁻¹X)`
   (and analogously for snd), giving
   `G.hom.c.app X ≫ (fst).left.c.app (G.hom⁻¹X) = G.hom.c.app X ≫ (snd).left.c.app (G.hom⁻¹X)`.
3. **Transpose through the adjunction** (`pullbackPushforwardAdjunction.homEquiv.symm`):
   construct `h` such that `(φ_LHS.app (snd⁻¹X)).comp h = (ψ.app X).comp (φ_G.app X)`.
4. **Discharge** with `(CommRingCat.KaehlerDifferential.D _).d_map _` (the
   `ModuleCat.Derivation.d_map` `@[simp]` lemma at
   `Mathlib/Algebra/Category/ModuleCat/Differentials/Basic.lean:80`).

### LOC envelope estimate (carry forward)
- Step 1: ~3–5 LOC (`Over.w` chain).
- Step 2: ~10–15 LOC (`PresheafedSpace.comp_c_app` applied twice + the
  combine identity).
- Step 3: ~20–40 LOC (adjunction-transpose chase; the main difficulty).
- Step 4: ~5–10 LOC (`d_map` discharge with `change` to align argument).
- **Total**: ~40–80 LOC, consistent with the iter-141 estimate.

### Why iter-142 did not close this
The categorical chase in Step 3 (constructing the witness `h` via
adjunction transpose) requires deep familiarity with
`TopCat.Presheaf.pullbackPushforwardAdjunction`'s `homEquiv.symm`
unfolding — the transpose is `(pullback f.base).map ≫ counit_app`, but
extracting the per-open ring-map shape of `h` requires manipulating
colimit-presented inverse-image presheaves. No Mathlib shortcut exists
(per `analogies/d-app-d-map-recipe-shape.md` Decision 2:
`NEEDS_MATHLIB_GAP_FILL` bespoke chase).

---

## IsIso at L689 — IN PROGRESS (iter-140 structural narrowing retained)

### Attempt 1: `infer_instance` / `apply`-based bypass
- **Approach**: see if Mathlib instance synthesis can close it directly.
- **Result**: FAILED. The `IsIso ((basechange_along_proj_two_inv G).app X)`
  fact is NOT a generic instance — it requires per-open identification
  with `KaehlerDifferential.tensorKaehlerEquiv.symm` modulo the
  chart-unfolding of `((pullback ψ).obj M_G).obj X`.

### Closure path (Route (b'2) per `analogies/isiso-basechange-along-proj-two-inv.md` Decisions 1+3)
**Iter-140 closed item 1 of 4** (the `isIso_of_app_iso_module`
iso-reflection bridge helper at `Cotangent/GrpObj.lean:544–550`). Items
2–4 are the iter-143+ targets:

1. ✓ `isIso_of_app_iso_module` helper (5 LOC; iter-140 close).
2. **[iter-143+]** Chart-level `Algebra.IsPushout`-from-affine-product
   helper (~80–150 LOC; shared with Route (a); upstream-PR candidate).
3. **[iter-143+]** `((pullback ψ).obj M).obj X` chart-unfolding helper
   `pullbackObjEquivTensor` (~30–60 LOC; shared with Route (a);
   upstream-PR candidate).
4. **[iter-143+]** Per-open identification with `tensorKaehlerEquiv.symm`
   via `tensorKaehlerEquiv_symm_D_tmul` (~80–150 LOC).

### Why iter-142 did not close this
Items 2 and 3 are infrastructure pieces shared with Route (a); both
require building chart-level affine-product `Algebra.IsPushout` and a
new `((pullback ψ).obj M).obj X` chart-wise tensor description. Neither
is packaged in Mathlib; both are genuine gap-fills (~110–210 LOC
combined). Item 4 then assembles them per-open. Total envelope
~195–365 LOC — significantly larger than what fits in a single prover
iter alongside the d_app + d_map closures. Iter-142 prioritized the
smaller, more tractable d_map closure (~30 LOC) over the IsIso
infrastructure build.

---

## Mathlib lemmas verified / consumed this iter

| Name | Module:Line | Used |
|---|---|---|
| `NatTrans.naturality_apply` | `Mathlib.CategoryTheory.ConcreteCategory.Basic:221` | d_map (closed) |
| `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d` | `Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf:201–207` | d_map (closed) |
| `PresheafOfModules.pushforward_obj_map_apply` | `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pushforward:95–97` | d_map (definitional `.map` unfold; not invoked by name) |
| `ModuleCat.Derivation.d_map` | `Mathlib.Algebra.Category.ModuleCat.Differentials.Basic:80` | d_app (planned for iter-143+; not yet invoked) |
| `PresheafedSpace.comp_c_app` | `Mathlib/Geometry/RingedSpace/PresheafedSpace.lean:176` | d_app (planned for iter-143+ Step 2) |
| `Over.w` | (Mathlib stdlib) | d_app (planned for iter-143+ Step 1) |

---

## Iter-143 prover handoff

If iter-143 prover targets this lane (PARTIAL arm fired per pre-commit
matrix; mid-iter strategy-critic should be dispatched per PROGRESS.md
L141 to decide between sub-decomposition pivot, structural side-step
refactor, or bundled Mathlib-PR detour):

1. **d_app** (smallest remaining; ~40–80 LOC): follow the 4-step recipe
   above. The categorical equality + comp_c_app pieces are routine; the
   adjunction-transpose Step 3 is the load-bearing chase. The explicit
   `change` block at L611–L618 has already exposed the goal in canonical
   form — start there.
2. **IsIso** (~195–365 LOC bundled): build items 2 + 3 of Route (b'2)
   first (smallest units), then item 4. If the chart-level
   `Algebra.IsPushout` helper (item 2) lands cleanly via
   `CommRingCat.isPushout_iff_isPushout` + `pullbackSpecIso` +
   `isPullback_SpecMap_of_isPushout` chain, the rest follows.
3. **PASS arm trigger** for iter-143+: closing d_app alone (without IsIso)
   would land 2 of 3 sub-sorries → triggers piece (i.b) Step 2 PASS arm
   → iter-144 fires Main `mulRight_globalises_cotangent` L833.

---

## Blueprint marker recommendations (review-agent action)

The Lean target `basechange_along_proj_two_inv_derivation` still
contains 1 inline `sorry` (the d_app at L624; d_map at L643 closed
this iter). The `\leanok` marker on the proof block of
`lem:GrpObj_omega_basechange_proj_inv_derivation` (`RigidityKbar.tex:1152`)
remains a candidate `sync_leanok` mis-mark — still has an inline sorry
inside the body. (Iter-142 carry-over from iter-141 watchpoint #4.)

The Lean target `relativeDifferentialsPresheaf_basechange_along_proj_two`
still contains 1 inline `sorry` (the IsIso per-open at L697; iter-140
narrowed). The `\leanok` marker on the proof block of
`lem:GrpObj_omega_basechange_proj` (`RigidityKbar.tex:524`) similarly
remains a `sync_leanok` mis-mark candidate.

No new `\notready` candidates to surface this iter; `mulRight_globalises_cotangent`
(L833) remains genuinely scaffold-only pending Step 2 substantive
closure.

## Iter-142 deliverable summary

- **+1 sub-sorry closed substantively (d_map)** ← only strict closure on
  this file since iter-138 (the iter-138 Route (b) skeleton landed 4 of
  4 derivation laws + 2 of 4 closed honestly).
- **+1 sub-sorry given an extended `change`-skeleton (d_app)** ← goal
  now in canonical form for iter-143+ takeover; no new infrastructure
  needed beyond the 4-step recipe above.
- **0 new helpers introduced this iter** (respecting progress-critic-iter142
  "NO 4th helper this iter" guardrail per PROGRESS.md L145).
- **0 protected signatures touched.**
- **0 new axioms.**
- **0 edits to other `.lean` files** (file-scope respected per prover
  prompt).
- **0 blueprint chapter edits** (review-agent domain).
