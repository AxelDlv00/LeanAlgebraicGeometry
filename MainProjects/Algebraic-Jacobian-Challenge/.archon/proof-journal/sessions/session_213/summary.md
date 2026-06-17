# Session 213 (iter-213) — review summary

## Metadata

- **Iteration / session:** 213
- **Lane:** TS (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`) — sole USER-permitted lane.
- **Sorry count:** 81 → 81 (net 0). TS-file code sorries 4 → 4.
- **Build:** GREEN (TS file compiles with 0 errors; only the known `ext`-pattern linter warning + the comment-scan `opaque` false-positive at L796).
- **Axioms on `tensorObj_assoc_iso`:** `{propext, sorryAx, Classical.choice, Quot.sound}` — `sorryAx` traces to the single residual only; NO project axioms.
- **`sync_leanok`:** ran for iter-213 (sha `f06415cc`), +1 / −1, chapter `Picard_TensorObjSubstrate.tex`.
- **Blueprint doctor:** no structural findings (no orphan chapters, all `\ref`/`\uses` resolve, no new `axiom`s).
- **Target attempted:** the 8-iter-stuck associator `tensorObj_assoc_iso`.

## Headline

The associator `tensorObj_assoc_iso` — STUCK since the iter-209 pivot — is now a **complete,
compiling 3-step composite with no `sorry` in its own body**, transitively depending on exactly
**one** clean, mathematically-true residual lemma. The monolithic associator `sorry` is gone;
in its place sit two newly-closed helper lemmas (`W_whiskerLeft_of_W`, `W_whiskerRight_of_W`)
and one new `sorry`-bodied residual (`isLocallyInjective_whiskerLeft_of_W`). Net file sorry
count is unchanged (4) because one sorry moved from the associator down to the residual; but the
qualitative state advanced from "scaffolded sorry on a wall" to "assembled construction waiting
on one feasibility-confirmed Mathlib-infra port."

**Route divergence (positive).** The plan agent dispatched on ROUTE (c) (local-on-cover
injectivity, `IsLocallyTrivial`-scoped). The prover instead executed ROUTE (d) (stalkwise,
flatness-free, arbitrary modules) — the sibling realization vetted in
`analogies/ts-monoidal213.md` (Decision 3). Route (d) is cleaner: the whiskered-unit `J.W` fact
holds for *arbitrary* modules, so the associator is strictly stronger than the blueprint
statement and the `IsLocallyTrivial` hypotheses `hM hN hP` are received but never consumed. The
prover confirmed route (c)'s pure-section variant is a genuine dead end (attempt 2, below),
validating the move.

## Target: `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` — PARTIAL (assembled modulo residual)

Re-scoped hypotheses `IsInvertible → LineBundle.IsLocallyTrivial` (decl is unprotected;
consumers use `IsLocallyTrivial`; matches the blueprint `lem:tensorobj_assoc_iso` signature).

**Final structure** (line ~659, compiles):
```
letI instMS : MonoidalCategoryStruct (PresheafOfModules (Sheaf.val X.ringCatSheaf)) :=
  inferInstanceAs (... (X.presheaf ⋙ forget₂ CommRingCat RingCat))   -- carrier bridge
set a := PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)
-- η = sheafificationAdjunction.unit;  toPresheaf(η.app A) = toSheafify ∈ J.W  (W_toSheafify)
have hW1 := W_whiskerRight_of_W P.val (η.app MN) hηMN
have hW3 := W_whiskerLeft_of_W  M.val (η.app NP) hηNP
have hi1 := isIso_sheafification_map_of_W _ _ hW1   -- step 1: a inverts whiskered unit
have hi3 := isIso_sheafification_map_of_W _ _ hW3   -- step 3
have e2  := a.mapIso ((monoidalCategoryStruct (R:=X.presheaf)).associator M.val N.val P.val)
exact (asIso hi1).symm ≪≫ e2 ≪≫ asIso hi3
```

**Key resolutions this iter:**
- The **iter-212 carrier-friction wall is GONE.** `Sheaf.val X.ringCatSheaf = X.presheaf ⋙ forget₂ CommRingCat RingCat` holds by `rfl`; the missing `MonoidalCategoryStruct` is supplied by `letI ... := inferInstanceAs (...)`. No more `synthInstance`/`whnf` heartbeat timeouts.
- `toPresheaf_map_sheafificationAdjunction_unit_app` (rfl) + `GrothendieckTopology.W_toSheafify` give `η ∈ J.W` cheaply.
- `isIso_sheafification_map_of_W` (closed iter-212) inverts both whiskered units.

## New closed helpers (section `WhiskerOfW`)

- **`W_whiskerLeft_of_W`** (L427) — SOLVED. `J.W (toPresheaf g) → J.W (toPresheaf (F ◁ g))` for **arbitrary** `F`. `rw [W_iff_isLocallyBijective]; exact ⟨residual, isLocallySurjective_whiskerLeft …⟩`. Surjectivity free (right-exactness); injectivity delegated to the residual.
- **`W_whiskerRight_of_W`** (L440) — SOLVED. Braiding-conjugate of the above (`g ▷ F = β ≫ (F ◁ g) ≫ β⁻¹`, then `cancel_left/right_of_respectsIso`). Mirrors `W_whiskerRight_of_flat`.

## The single residual: `isLocallyInjective_whiskerLeft_of_W` (L419) — BLOCKED (Mathlib-infra)

**Statement (TRUE, substantive, correctly quantified):** for arbitrary `F` and `g` with
`J.W (toPresheaf g)`, `IsLocallyInjective J (F ◁ g)`. Stalkwise `(F ◁ g)_x = id_{F_x} ⊗ g_x`;
a `J.W`-map is a stalkwise iso, and `id ⊗ iso` is an iso — so `F ◁ g` is a stalkwise iso, hence
locally bijective, hence locally injective. No flatness, no local triviality.

**Why iters 206–212 were stuck (root-cause, now understood):** they split `J.W` into inj+surj
and tried to preserve *injectivity alone*, which genuinely needs flatness (false for invertibles
over non-affine opens). Preserving the *combined iso* (stalkwise) needs no flatness.

**Why it could not close this iter — two Mathlib-absent ingredients (LSP/leansearch-verified):**
- **(d.1)** module-level stalkwise characterisation of `J.W` on `Opens X`
  (`J.W (toPresheaf f) ↔ ∀ x, IsIso ((stalkFunctor x).map …)`). Mathlib has only the TopCat-sheaf /
  separated forms (`app_injective_iff_stalkFunctor_map_injective`,
  `locally_surjective_iff_surjective_on_stalks`), not bridged to
  `CategoryTheory.Presheaf.IsLocallyInjective (Opens.grothendieckTopology X)`.
- **(d.2)** stalk commutes with the relative module tensor: `(A ⊗ᵖ B)_x ≅ A_x ⊗_{R_x} B_x`.
  Mathlib has only the sectionwise `tensorObj_obj`; the filtered-colimit version over the varying
  ring `R(U)` does not exist.

~200–400 LOC stalk-infrastructure port. **NOT a dead end** — the technique is Mathlib-blessed
(`Sites.Point.IsMonoidalW` + `TopCat.hasEnoughPoints`, 2026; hardest input "enough points for
`Opens X`" already ships). Full write-up at `informal/isLocallyInjective_whiskerLeft_of_W.md`.

### Attempt log (residual)
- **Attempt 1 (ROUTE d, stalkwise):** left as typed `sorry`; (d.1)+(d.2) verified Mathlib-absent.
- **Attempt 2 (pure-section / route-c flavour):** FAILED — `ker(id_F ⊗ g_U)` is NOT generated by
  `F ⊗ ker(g_U)` without flatness (Tor₁ obstruction), so `Module.Flat.lTensor_exact` (used by the
  flat-route `isLocallyInjective_whiskerLeft_of_flat`) has no flatness-free section-level swap.
  Route (c) sub-site restriction also needs absent infra and gives a messier residual. Dead end.
- Negative searches: "stalk of tensor of presheaves of modules" → nothing; "locally injective iff
  stalk injective (Opens topology)" → only sheaf/separated versions.

## Subagent findings (full reports linked; do not re-read here)

- **lean-auditor ts213** (`task_results/lean-auditor-ts213.md`) — new proof work mathematically
  coherent, residual correctly stated/quantified. **4 must-fix**, all docstring staleness in the
  `.lean` file (review cannot edit `.lean`): (1) the residual `sorry` at L419 [expected]; (2)
  `tensorObj_assoc_iso` docstring L622–658 severely stale (describes the abandoned flatness/iter-212
  route, not the ROUTE (d) body); (3) `tensorObj` docstring L498 still claims "typed sorry" on a real
  def; (4) `tensorObj_functoriality` docstring L512 same. Major: `W_whiskerLeft/Right_of_W` are
  undisclosed transitive sorrys at call sites; dead `hM hN hP`; stale file module docstring L37.
- **lean-vs-blueprint-checker ts213** (`task_results/lean-vs-blueprint-checker-ts213.md`) — **1
  must-fix**: the three new `WhiskerOfW` lemmas (esp. the sorry residual) have NO `\lean{...}` pins,
  so the sole open obligation is invisible in the blueprint. Major: (a) `lem:tensorobj_assoc_iso`
  proof sketch describes the locally-trivial-cover route while Lean uses ROUTE (d) [Lean is source of
  truth]; (b) `lem:tensorobj_lift_onproduct` prose misidentifies `LineBundle.OnProduct` as the
  `IsInvertible` subtype — it is the `IsLocallyTrivial` subtype, and the Lean body uses only
  `tensorObj_isLocallyTrivial`; (c) `tensorObjIsoclassCommMonoid` pinned but unscaffolded. Minor:
  `\leanok` missing on `lem:flat_whisker_localizer` and `lem:tensorobj_unit_iso` (sync_leanok gap).

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_assoc_iso`: added `% NOTE (iter-213)` flagging the
  ROUTE (d) divergence, the unused `IsLocallyTrivial` hyps, and the unpinned residual
  `isLocallyInjective_whiskerLeft_of_W` as the sole open obligation.
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_lift_onproduct`: added `% NOTE (iter-213)` flagging
  the `LineBundle.OnProduct` carrier-predicate mismatch (IsLocallyTrivial vs IsInvertible) and the
  incorrect `\uses`.

(No `\leanok` touched — owned by sync_leanok. No `\mathlibok` added — no Mathlib re-export decls this
iter. No `\lean{}` renames — associator name unchanged; the three new lemmas need NEW pins, which is
blueprint-writer prose work, not a review correction.)

## Key findings / patterns

- **Preserve the combined iso, not injectivity alone.** Whiskering by an arbitrary module
  preserves *local bijectivity* (`J.W`) flatness-free, because `J.W`-maps are stalkwise isos and
  `id ⊗ iso` is an iso. Splitting into inj+surj and chasing injectivity alone forces flatness — the
  trap that consumed iters 206–212.
- **Carrier-friction recipe:** `Sheaf.val X.ringCatSheaf = X.presheaf ⋙ forget₂ CommRingCat RingCat`
  is `rfl`; transport a missing instance across it with `letI ... := inferInstanceAs (...)`. This
  dissolved the iter-212 heartbeat-timeout wall.

## Recommendations for next session

See `recommendations.md`. Headline: the next TS lane is a **dedicated stalk-infrastructure build**
(port d.1 + d.2 to `PresheafOfModules`) to close the one residual — NOT another associator
realization, and NOT a substrate pivot (4 realizations now mapped; ROUTE (d) is sound and the
associator is built around it). A blueprint-writer pass must pin the three `WhiskerOfW` lemmas and
rewrite the associator proof sketch to ROUTE (d) before/with that dispatch.
