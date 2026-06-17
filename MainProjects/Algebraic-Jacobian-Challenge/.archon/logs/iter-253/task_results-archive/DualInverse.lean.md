# Picard/TensorObjSubstrate/DualInverse.lean — iter-252 (Lane TS-inv)

## Summary
- **sorry count: 2 → 2** (no net count change), but a new **axiom-clean** load-bearing helper was
  added and the PRIMARY target was reduced from a bare `sorry` to a documented compiling scaffold.
- **Closed (new, axiom-clean):** `homLocalSection` — the blueprint's load-bearing `localSection`
  (incl. its naturality field, the documented "genuine coherence risk"). `#print axioms` =
  `[propext, Classical.choice, Quot.sound]` (no `sorryAx`).
- **Still open:**
  - `homOfLocalCompat` (L510): bare `sorry` → **real compiling scaffold** (hom-sheaf `H`,
    `iSup U = ⊤`, the `existsUnique_gluing` call fed with `homLocalSection U f`) ending in one
    `sorry` for {compatibility-from-`hf`, terminal-section→morphism conversion, sectionwise
    linearity + `homMk`}.
  - `dual_restrict_iso` Step-4 (L256): **untouched this iter** — Step A consumed the budget.
- **Adjacent sorries:** attempted `homOfLocalCompat` (assigned PRIMARY); did NOT attempt
  `dual_restrict_iso` Step-4 (Step B).
- **Required MUST-FIX doc cleanups (aud251): DONE** — relabeled module header L25
  ("dual_isLocallyTrivial CLOSED" → "TRANSITIVELY PARTIAL"); fixed the "Uses (all CLOSED):"
  inconsistency at ~L288.
- **File builds** (`lake build … DualInverse` = "Build completed successfully"). Both new decls
  also verified standalone against Mathlib under the real `open` structure.

## homLocalSection (NEW, CLOSED axiom-clean)
### Approach — RESOLVED
Built the local section of `presheafHom M.val.presheaf N.val.presheaf` over `U i` directly as a
`NatTrans` (value of `presheafHom … .obj (op (U i))`):
- **`app W`** (the component): `M.val.presheaf.map (eqToHom h.symm) ≫ ((toPresheaf _).map (f i).val).app (op ((U i).ι ⁻¹ᵁ W.left)) ≫ N.val.presheaf.map (eqToHom h)`,
  where `h : (U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ W.left) = W.left` (from `Scheme.Hom.image_preimage_eq_opensRange_inf` + `inf_eq_right.mpr W.hom.le`).
  Crucial defeq used: `restrict_obj`/`restrict_map` are `rfl`, so `(M.restrict (U i).ι).val.presheaf.obj/map`
  is **definitionally** `M.val.presheaf.{obj,map}` at the image open.
- **`naturality`** (the load-bearing field): reduced to the naturality `hm` of
  `(toPresheaf _).map (f i).val`, conjugated by two **thin-poset `Subsingleton.elim`** edge
  equalities `hsubM`/`hsubN` (any two parallel maps in `(Opens X)ᵒᵖ` are equal), packaged as
  `hML` (M-side) and `hNR` (N-side) via `Functor.map_comp`.

### KEY IDIOMS / DEAD-ENDS (carrier-friction wall — record for reuse)
- The composites mix `M.val.presheaf.{obj,map}` (image form) with `(M.restrict …).val.presheaf`
  (restrict form) at the `((toPresheaf).map (f i).val).app` boundary; these are **defeq but not
  syntactic**. This breaks `rw`/`simp`/`slice` on `Functor.map_comp` and `Category.assoc`
  *asymmetrically* (one side merges, the other "pattern not found"; `Category.assoc` silently
  rewrites the *other* side).
- WORKING RECIPE (verified):
  1. State `hML` with RHS in **restrict form** `(M.restrict (U i).ι).val.presheaf.map κ.op`
     (so its boundary with `m_preB` is syntactic), prove it with
     `rw [(F.map_comp _ _).symm, hsubM]; exact F.map_comp _ _` (NOT `← Functor.map_comp` twice —
     the second occurrence fails to match).
  2. State `hNR` in **pure `N.val.presheaf` form** and apply it with **`erw`** (defeq-matching)
     in the main chain.
  3. Main chain: `rw [← Category.assoc, hML]; erw [Category.assoc, reassoc_of% hm, hNR]; simp only [Category.assoc]; rfl`.
     `erw` is essential for the assoc step across the restrict/image boundary; the final
     `simp only [Category.assoc]` + `rfl` discharges the 4-fold associativity + `eqToHom`
     proof-irrelevance residual.
- DEAD: plain `rw [Functor.map_comp]` / `simp only [Functor.map_comp]` forward-split (never matches
  the `opensFunctor`-image factor); `slice_lhs` (treats a defeq-boundary 2-comp as one atomic
  factor); term-mode `congrArg F.map (Subsingleton.elim _ _)` inside a `.trans` chain (whnf
  timeout — Subsingleton args underdetermined).

## homOfLocalCompat (scaffold + sorry)
Verified-compiling scaffold:
```
let H : TopCat.Sheaf (Type u) X := ⟨presheafHom M.val.presheaf N.val.presheaf,
  Presheaf.IsSheaf.hom _ _ N.isSheaf⟩
have hsup : iSup U = ⊤ := …            -- from hU, via Opens.mem_iSup
have hglue := H.existsUnique_gluing U (fun i => homLocalSection U f i)
sorry
```
Remaining residual (the next-iter work, all reduced to standard gluing bookkeeping):
- **(a)** `IsCompatible H.1 U (homLocalSection U f)` — feed `hglue`; this is exactly `hf`
  (HEq overlap agreement of the two double-restrictions on `U i ⊓ U j`). Likely needs the
  `PresheafHom.isAmalgamation_iff`/sectionwise comparison + transporting `hf`'s HEq through the
  `eqToHom`-conjugation in `homLocalSection`.
- **(b)** terminal-section → morphism: the glued section lives in `H.1.obj (op (iSup U))` with
  `iSup U = ⊤`; `⊤` is terminal in `Opens X`, so this is `≅ (M.val.presheaf ⟶ N.val.presheaf)`
  (cf. `presheafHomSectionsEquiv`, which is stated for `.sections` — need the `op ⊤ ↔ .sections`
  bridge, or hand-build `g.app W := s.app (op (Over.mk (homOfLE le_top)))`).
- **(c)** sectionwise `𝒪_X`-linearity `hg` of `g` (holds on each `U i` since `g|_{U i}` is the
  module map `f i`; ambient presheaf separated ⇒ global), then `Scheme.Modules.homMk g hg : M ⟶ N`.

## dual_restrict_iso Step-4 (L256) — NOT attempted this iter
Budget went to Step A (PRIMARY `homOfLocalCompat`). Plan unchanged (dual252): leg (A)
`sliceDualTransport` (standalone first) + leg (B) `restrictScalarsRingIsoDualEquiv`, OR the
inverse-uniqueness shortcut from `tensorObj_restrict_iso`.

## Blueprint markers (for review agent)
- `lem:sheafofmodules_hom_of_local_compat` (`homOfLocalCompat`): still has a `sorry` → NOT `\leanok`
  (sync handles). But its load-bearing `localSection` is now a real axiom-clean decl — consider a
  `\lean{}` pin / sub-lemma block for `homLocalSection` if the planner wants it tracked.

## Why I stopped
**Partial progress (real code).** Closed `homLocalSection` (new, axiom-clean) — the blueprint-
mandated load-bearing sub-piece of `homOfLocalCompat`, including the hard naturality field that
required defeating the documented restrict/image carrier-friction wall (recipe above). Reduced
`homOfLocalCompat` from a bare `sorry` to a compiling scaffold that constructs the hom-sheaf and the
gluing call from `homLocalSection`, leaving one `sorry` for the standard
compatibility/conversion/linearity bookkeeping. Did not reduce the raw `sorry` *count* (still 2),
and did not touch `dual_restrict_iso` Step-4 — the entire budget was spent verifying the
naturality field through ~10 compile iterations against the carrier-friction wall (the sibling
`TensorObjSubstrate.lean` was non-compiling for most of the session, forcing me to verify every step
in an isolated Mathlib-only scratch file; the sibling lane fixed its file near the end and the full
real file now builds).
