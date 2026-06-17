# Session 251 — review of iter-251

## Metadata
- **Iteration / session:** 251
- **Model:** opus (both lanes)
- **Mode:** `prove` (both lanes)
- **Lanes:** TWO parallel — first iter the route is structurally split (D2′ closed iter-250 de-gated an independent second workstream).
  - **Lane TS-cmp** — `Picard/TensorObjSubstrate.lean` (D1′ comparison-naturality)
  - **Lane TS-inv** — `Picard/TensorObjSubstrate/DualInverse.lean` (NEW file; dual-inverse chain)
- **Sorry counts (the two touched files):**
  - `TensorObjSubstrate.lean`: **1 → 3** (L705 `exists_tensorObj_inverse` unchanged; +L1954 `sheafifyTensorUnitIso_hom_natural`; +L1983 `pullbackTensorMap_natural`/D1′). Net +2 sorries BUT +2 NEW closed reusable lemmas.
  - `DualInverse.lean` (scaffolded this iter with 3 stubs): **3 → 2** (`dual_isLocallyTrivial` assembled; `dual_restrict_iso` L254 + `homOfLocalCompat` L420 open).
- **Build:** GREEN both files — 0 errors (verified first-hand via `lean_diagnostic_messages`, severity=error → empty). The mid-session parallel-lane race (TS-cmp left the shared import broken) RESOLVED by end of iter.
- **Canonical critical-path counter:** FLAT (no canonical Picard sorry eliminated this iter; D2′ was the iter-250 win). This is a partial-progress iter on two lanes, not a close.

## What was attempted and what landed

### Lane TS-cmp — D1′ `pullbackTensorMap_natural` (naturality of the sheaf-level pullback–tensor comparison)
Planner asked "Author + prove" D1′ then D3′/D4′. D1′ is a 4-square diagram paste. Outcome:

- **`pullbackValIso_hom_natural` (L1879) — CLOSED, axiom-clean.** VERIFIED first-hand:
  `{propext, Classical.choice, Quot.sound}`, no `sorryAx`. Square 4 of D1′. Worked through the
  `SheafOfModules.pullback φ` vs `Scheme.Modules.pullback f` carrier friction. Working idiom kit
  (reusable for the remaining squares + D3′):
  1. `erw [(sheafificationCompPullback φ).inv.naturality u.val]` (`erw` matches `(α.app M').inv ≡ α.inv.app M'` and `(F⋙a_Y).map ≡ a_Y.map(F.map)` up to defeq);
  2. morphism-level `rw [show (SheafOfModules.pullback φ).map g = (Scheme.Modules.pullback f).map g from rfl]` (functor-level breaks the motive);
  3. `erw [Category.assoc]` (plain `rw` fails — mixed category instance);
  4. fully-EXPLICIT `erw [← Functor.map_comp F g1 g2]` to merge (a metavar functor whnf-bombs);
  5. `congr 1; congr 1; exact (sheafificationAdjunction ..).counit.naturality u`.
  - **Correction recorded:** the earlier "`exact` bombs" diagnosis was WRONG — the heartbeat bomb was a stray `rw [← restrictScalarsId_map]`; plain `exact …counit.naturality u` succeeds.

- **`sheafifyTensorUnitIso_hom_eq` (L1853, private) — CLOSED by `rfl`.** Carrier-normalisation brick:
  strips the `letI instMS` cast from `sheafifyTensorUnitIso.hom`, restating it on the `⋙ forget₂`
  carrier so `Functor.map_comp` merges fire. (Pattern = the iter-250 `restrictScalarsId_map := rfl` strip.)

- **`sheafifyTensorUnitIso_hom_natural` (L1914, sorry L1954) — PARTIAL.** Square 3. Reduced from
  "blocked at the very first merge" to ONE concrete whisker identity with the hand-proof spelled out:
  ```
  rw [sheafifyTensorUnitIso_hom_eq, sheafifyTensorUnitIso_hom_eq]  -- carrier-normalise
  rw [← Functor.map_comp, ← Functor.map_comp]                       -- merge whisker pairs
  erw [← Functor.map_comp, ← Functor.map_comp]                      -- merge a.map(p⊗q) (defeq-not-syntactic)
  congr 1; simp only [MonoidalCategory.tensorHom_def]               -- expand ⊗ to whiskers
  ```
  Residual goal (whisker identity): `(p ▷ Q ≫ P' ◁ q) ≫ (η_{P'} ▷ Q') ≫ ((aP').val ◁ η_{Q'}) = (η_P ▷ Q) ≫ ((aP).val ◁ η_Q) ≫ ((a.map p).val ▷ (aQ).val) ≫ ((aP').val ◁ (a.map q).val)`.
  - **BLOCKER:** `whisker_exchange[_assoc]`, `comp_whiskerRight`, `whiskerLeft_comp` ALL fail to fire (rw/simp report "unused"/"not found") — the goal's `▷`/`◁` come from the file's local
    `MonoidalCategoryStruct` (forget₂ carrier), defeq-but-not-syntactic to `MonoidalCategory.toMonoidalCategoryStruct`. THIRD instance of the `.val`/carrier friction class solved twice this session.
  - **Next step:** author a whisker-carrier restatement lemma (analogue of `sheafifyTensorUnitIso_hom_eq`) re-stating the local `▷`/`◁` via the canonical `MonoidalCategory` instance.

- **`pullbackTensorMap_natural` (L1960, sorry L1983) — D1′ target, PARTIAL.** 4-square paste; 2
  helpers exist (one closed, one at its final whisker residual); the other 2 squares are
  `δ_natural` (square 2) / `sheafificationCompPullback` naturality (square 1). Body leaves
  `simp only [pullbackTensorMap, tensorObj_functoriality]` + a documented assembly plan.
- **D3′ / D4′ — NOT STARTED** (correctly gated on D1′ closing).
- **Reversing signal "D1′ does not close → re-decompose" FIRED:** D1′ is NOT the planner's "2-step";
  it needs two non-packaged naturality helpers.

### Lane TS-inv — dual-inverse chain (new `DualInverse.lean`)
Chain: `dual_restrict_iso` → `dual_isLocallyTrivial` → `homOfLocalCompat` → (feeds `exists_tensorObj_inverse`).

- **`presheafDualUnitIso` + `unitDualSectionEquiv` + `dualUnitIsoGen` + `dual_unit_iso` — CLOSED,
  axiom-clean** (4 new decls). `presheafDualUnitIso` VERIFIED first-hand: `{propext, Classical.choice, Quot.sound}`, no `sorryAx`. The `dual 𝒪_Y ≅ 𝒪_Y` leg, sheafifying the presheaf-level
  `PresheafOfModules.dual 𝟙_ ≅ 𝟙_` (= `ℋom(𝟙_,𝟙_) ≅ 𝟙_`, evaluation at 1). Built generally over
  `{D}[Category D]{R₀ : Dᵒᵖ ⥤ CommRingCat}`, instantiated at `R₀ := Y.presheaf`. Developed + verified
  in an isolated scratch (PresheafInternalHom-only), then ported verbatim, scratch DELETED (confirmed —
  `ScratchDualUnit.lean` no longer on disk). Substantive content: `left_inv` (every unit-endomorphism
  is mult by its value at 1) + `internalHomEval`-style naturality. Idioms: `erw` for
  `globalSMul_hom_apply`/`unit_map_one` defeq; `1` ascribed `(1 : (R₀⋙forget₂..).obj X)` to dodge
  `OfNat` synthesis; pin `internalHomObjModule` with `letI`.

- **`dual_isLocallyTrivial` (L330) — body assembled, TRANSITIVELY PARTIAL.** Chart-chase:
  `intro x; obtain ⟨U,…,⟨eL⟩⟩ := hL x; exact dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`.
  **VERIFIED first-hand: carries `sorryAx`** transitively (axioms `{propext, sorryAx, Classical.choice, Quot.sound}`) because it references `dual_restrict_iso` which has an open Step-4 sorry. The task result
  and the in-file module header at L25 mislabel it "**CLOSED**" — see Findings below; **lean-auditor must-fix**.

- **`dual_restrict_iso` (L228, sorry L254) — PARTIAL.** Steps 1–3 (`restrictFunctorIsoPullback`,
  `sheafificationCompPullback`, strip outer sheafification via `.mapIso`) + H1 (`pushforwardPushforwardAdj ∘ leftAdjointUniq` rewrites `pullback φ` to `pushforward β`) all typecheck. Residual: a presheaf-of-modules iso
  `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` — the dual analog of the H2
  `restrictScalarsMonoidalOfBijective` tensorator, sectionwise via `InternalHom.restrictScalarsRingIsoDualEquiv`.
  Left as a SINGLE typed sorry — deliberately NOT thrashed, honoring the pc251 warm-context warning.

- **`homOfLocalCompat` (L420) — NOT STARTED.** The planner's stated minimum; prover judged the
  dual-iso chain higher-value and ran out of budget. Multi-piece sheaf-of-homs gluing engine
  (`Presheaf.IsSheaf.hom` + `existsUnique_gluing` through `overSliceSheafEquiv` + `homMk`). Recipe in the in-file stub.

## Key findings / patterns

1. **`.val`/carrier friction is the dominant obstacle on BOTH lanes** — the same class that gated
   D2′ for 11 iters. This iter it appears as: (a) `pullback φ` vs `pullback f` morphism rewrites
   (SOLVED via the `erw` idiom kit + `show … from rfl`); (b) whisker projections from a local
   `MonoidalCategoryStruct` not unifying with Mathlib's `whisker_exchange`/`comp_whiskerRight`
   (OPEN — needs a whisker-carrier restatement); (c) `CommRingCat`/`RingCat` carrier blocking
   `LinearMap.add_apply` (SOLVED — `evalLin_add` is `rfl`-level, so `map_add' := rfl`). **The proven
   corrective is a per-context carrier-normalisation `:= rfl`/characterisation lemma** (e.g.
   `sheafifyTensorUnitIso_hom_eq`), then plain/`erw` rewriting fires.

2. **Honesty gap (must-fix, confirmed first-hand):** `dual_isLocallyTrivial` is labelled "CLOSED"
   in both the task result and the `DualInverse.lean` module header (L25) but carries `sorryAx`
   transitively via `dual_restrict_iso`. The body has no own-sorry, but the lemma is NOT
   axiom-clean. lean-auditor aud251 raised this as the single must-fix.

3. **Stale sorry-counts** in `TensorObjSubstrate.lean` header (L44 says "ONE tracked sorry"; actually
   THREE) and L123 sub-module inventory. lean-auditor major.

4. **Scratch-verify-then-port** worked cleanly for the `presheafDualUnitIso` §0 block (isolated
   PresheafInternalHom-only scratch, 0 warnings/errors/sorry, ported verbatim, scratch deleted).
   A reusable workflow for axiom-clean infra under heavy carrier friction.

## Subagent reports
- **lean-auditor aud251** — `task_results/lean-auditor-aud251.md`. 1 must-fix (false "CLOSED" on
  `dual_isLocallyTrivial`), 2 major (stale TS sorry-counts L44/L123), 5 minor (duplicate comment
  L1821–1823; `backward.isDefEq.respectTransparency` pragma L1654; wasted `maxHeartbeats` L1909;
  planner-strategy in docstrings; Uses-all-CLOSED inconsistency L293). 0 excuse-comments; all 4
  sorries honestly typed. Confirms my first-hand `sorryAx` finding.
- **lean-vs-blueprint-checker ts251** — see `task_results/lean-vs-blueprint-checker-ts251.md`.
- **lean-vs-blueprint-checker dualinv251** — see `task_results/lean-vs-blueprint-checker-dualinv251.md`.

## Blueprint markers updated (manual)
- None. No Mathlib re-export / alias was added (all new decls are Archon-original proofs), so no
  `\mathlibok`. No `\lean{...}` renames flagged. `\leanok` is owned by `sync_leanok` (ran iter-251,
  +4 in `Picard_TensorObjSubstrate.tex`); `dual_isLocallyTrivial`'s proof correctly did NOT receive a
  `\leanok` (it carries `sorryAx`). See `## Blueprint markers` follow-up after the blueprint-checkers
  return for any `% NOTE:` additions.

## Recommendations for iter-252
See `recommendations.md`.
