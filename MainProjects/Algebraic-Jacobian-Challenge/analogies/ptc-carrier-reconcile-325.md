# Analogy: reconciling `Sheaf.val (X.ringCatSheaf)` vs `X.presheaf ⋙ forget₂ CommRingCat RingCat` carrier spellings for a `rw`/`slice` naturality slide

## Mode
api-alignment

## Slug
ptc-carrier-reconcile-325

## Iteration
325

## Question
Canonical Mathlib idiom for rewriting a naturality/coherence lemma across two
def-eq but syntactically-distinct carrier spellings (`Sheaf.val X.ringCatSheaf`
vs `X.presheaf ⋙ forget₂ CommRingCat RingCat`) in a `slice`/`rw`/`kabstract`
context. The broken site: `slice_lhs 1 2 => rw [scPb_slide h]` in
`pullbackTensorMap_restrict` fails "pattern not found" because `scPb_slide`'s
`{P P'}` carrier is `Sheaf.val Y.ringCatSheaf` but the goal's is `⋙ forget₂`.

## Project artifact(s)
- `Picard/TensorObjSubstrate/PullbackTensorComp.lean:967-975` — `scPb_slide`, carrier `Sheaf.val Y.ringCatSheaf` (BROKEN).
- `…:460` — `sheafificationCompPullback_comp`, carrier `X.presheaf ⋙ forget₂ CommRingCat RingCat` (WORKS; `rw`'d at :1132 in the SAME goal).
- `…:1220-1224` — the failing slide, under `set_option backward.isDefEq.respectTransparency true`.

## Key Mathlib facts (cited)
- `CategoryTheory.Sheaf.val` is **`@[deprecated "Use ObjectProperty.obj" (since := "2026-03-03")]`**, `abbrev Sheaf.val (F : Sheaf J A) := F.obj` — `Mathlib/CategoryTheory/Sites/Sheaf.lean:309-310`. The project is using a **deprecated accessor**; canonical is `.obj` (`ObjectProperty.obj`/`FullSubcategory.obj`).
- `Sheaf J A := ObjectProperty.FullSubcategory (Presheaf.IsSheaf J)` — `Sheaf.lean:302`. Projection field = `.obj`.
- `TopCat.Sheaf C X := Sheaf (Opens.grothendieckTopology X) C` is a **`nonrec def`** (semireducible, NOT an abbrev) — `Mathlib/Topology/Sheaves/Sheaf.lean:108`. So `Sheaf.val X.ringCatSheaf` forces a `def`-unfold of `TopCat.Sheaf` → elaborator note "X.ringCatSheaf has type TopCat.Sheaf RingCat but expected ObjectProperty.FullSubcategory (Presheaf.IsSheaf …)". `kabstract` under `respectTransparency true` (strict, the slide's setting at :1220) will not see through this; under `false` (the lemma-level setting used at :1132) it does — which is exactly why the sibling lemma matches and `scPb_slide` does not.
- `Scheme.ringCatSheaf X := (sheafCompose _ (forget₂ CommRingCat RingCat)).obj X.sheaf` is an **`abbrev`** — `Mathlib/AlgebraicGeometry/Modules/Presheaf.lean:34`. Its `.obj` reduces to `X.sheaf.val ⋙ forget₂ … = X.presheaf ⋙ forget₂ CommRingCat RingCat`.
- `Scheme.PresheafOfModules X := PresheafOfModules.{u} X.ringCatSheaf.obj` — `Presheaf.lean:38`. Mathlib's `SheafOfModules.sheafificationCompPullback` (`Algebra/Category/ModuleCat/Sheaf/PullbackContinuous.lean:118`) is stated over abstract `{S R : Sheaf … RingCat}` and uses `S.obj`/`R.obj`, never `Sheaf.val`.
- No `sheafCompose_obj`-style simp lemma exists that cleanly normalizes `(sheafCompose F).obj G` to `G.val ⋙ F` (grep of `Sites/Whiskering.lean` found none).

## Decisions identified

### Decision: how to spell `scPb_slide`'s carrier so `rw`/`slice` matches the goal
- **Mathlib idiom**: state coherence/naturality helpers over the **canonical carrier the surrounding API already uses**, never a deprecated/parallel accessor. Mathlib's `sheafificationCompPullback` is poly in `{S R}` and uses `S.obj` (`PullbackContinuous.lean:118-126`); `Scheme.PresheafOfModules` uses `X.ringCatSheaf.obj` (`Presheaf.lean:38`). The in-file working twin `sheafificationCompPullback_comp` (`:460`) uses `X.presheaf ⋙ forget₂ CommRingCat RingCat` and its `rw` matches THIS goal at `:1132`.
- **Project's path**: `scPb_slide` pins `Sheaf.val Y.ringCatSheaf` — a deprecated abbrev applied to a `TopCat.Sheaf`-typed term, requiring a `def`-unfold that strict-transparency `kabstract` refuses.
- **Gap**: divergent-with-cost (rw fails to match; one stuck lemma blocks the whole D3′ assembly).
- **Verdict**: **ALIGN_WITH_MATHLIB.**

## Recommendation (ranked idioms)

### Idiom 1 — carrier-agnostic / canonical restatement  ✅ RECOMMENDED
Restate `scPb_slide`'s carrier to the goal's spelling. Two interchangeable canonical forms:

- **1a (BEST — match the working sibling): use `(W.presheaf ⋙ forget₂ CommRingCat RingCat)`** exactly as `sheafificationCompPullback_comp` (`:460`). That lemma's `rw` already matches the very goal `scPb_slide` is fighting (`:1132`), so the goal demonstrably carries this spelling. Edit: in `scPb_slide` (`:967-975`) replace
  - `{P P' : _root_.PresheafOfModules (Sheaf.val Y.ringCatSheaf)}` → `… (Y.presheaf ⋙ forget₂ CommRingCat RingCat)`
  - `𝟙 (Sheaf.val Z.ringCatSheaf)` → `𝟙 (Z.presheaf ⋙ forget₂ CommRingCat RingCat)`
  - `𝟙 (Sheaf.val Y.ringCatSheaf)` → `𝟙 (Y.presheaf ⋙ forget₂ CommRingCat RingCat)`
  The proof body `((sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom.naturality g).symm` is unchanged (defeq).
- **1b (equally canonical, Mathlib-uniform): use `W.ringCatSheaf.obj`** (= `Scheme.PresheafOfModules W`). This is the spelling Mathlib's own `sheafificationCompPullback` carries (`S.obj`). Prefer 1a only because it is byte-for-byte the spelling the goal is proven to expose at `:1132`; under strict transparency an exact syntactic match is safest.

Either way, **stop using `Sheaf.val`** — it is deprecated (`Sheaf.lean:309`).

### Idiom 2 — `dsimp`/`change` normalization before `rw`  (fallback only)
If, under `respectTransparency true`, idiom 1a still mismatches (e.g. the goal term is `W.ringCatSheaf.obj` un-reduced rather than `⋙ forget₂`), normalize first:
- `change`/`show` the carrier to the explicit `⋙ forget₂` form (defeq, cheap), or
- `dsimp only [Scheme.ringCatSheaf]` (abbrev) then let `.obj`/`sheafCompose` reduce.
There is **no dedicated simp lemma** (`Sheaf.val`/`sheafCompose_obj`) that does this in one named step — `[gap]`. Brittle; reach for it only if 1a fails. Cheaper alternative: drop the `set_option … respectTransparency true in` override at `:1220` so the slide inherits the lemma-level `false` (the aggressive defeq that makes `:1132` match). iter-324 established default-transparency does NOT whnf-explode here, so the `true` override is likely the proximate cause of the strict mismatch — try removing it together with 1a.

### Idiom 3 — `SheafOfModules ↔ PresheafOfModules` carrier-bridge iso  ✗ [gap]/not applicable
No carrier-spelling iso exists or is warranted — the carriers are **definitionally equal**, so an `Iso` would be overkill. `sheafificationCompPullback`/`pullbackIso` (`PullbackContinuous.lean:118,106`) ARE the functor-level bridges, but they reconcile FUNCTORS (sheafify∘pullback ≅ pullback∘sheafify), not the `Sheaf.val`-vs-`⋙forget₂` object-carrier spelling. Do not route through them for this.

### Parallel sub-blocker (stuck `OplaxMonoidal.δ` instance metavar)
Dissolved by idiom 1: routing step (1) through `scPb_slide` (= plain `NatTrans.naturality`) means the standalone `Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ) M N` term — whose `MonoidalCategory`/`OplaxMonoidal` instance over the `Sheaf.val`-vs-`⋙forget₂` carrier stays a stuck metavar (iter-257) — never has to be written. The call-site `Scheme.Modules.pullback h` fixes the carrier and synthesizes its instances. The roadmap (`:1206-1210`) already abandons the δ-spelling route for `scPb_slide`; idiom 1 completes that pivot.

## One-line fix for the prover
In `scPb_slide` (`:967-975`) replace the 3 `Sheaf.val W.ringCatSheaf` occurrences with `W.presheaf ⋙ forget₂ CommRingCat RingCat` (matching working sibling `sheafificationCompPullback_comp` `:460`); if the strict-transparency slide still won't match, also remove the `set_option backward.isDefEq.respectTransparency true in` at `:1220`.
