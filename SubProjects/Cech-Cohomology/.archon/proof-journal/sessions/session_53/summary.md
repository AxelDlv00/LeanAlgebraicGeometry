# Session 53 (iter-053) — review summary

## Metadata
- **Session / iter:** 53 / 053. Model: claude-opus-4-8.
- **Inline sorry count:** 2 (frozen) → **5** = 2 frozen + 3 *new scaffold* sorries opened this iter
  in the two new files (CechAugmentedResolution: 1; OpenImmersionPushforward: 2). No sorry was
  *closed*; none was *forced/papered*. The frozen two are unchanged: `CechAcyclic.lean:110` (dead
  `affine`), `CechHigherDirectImage.lean:780` (protected P5b `cech_computes_higherDirectImage`).
- **Build:** GREEN. Prover ran full `lake env lean` on both new files — exit 0, only the expected
  `uses sorry` warnings. `lean_verify` axiom-clean on all 4 new *completed* declarations.
- **Lanes planned 2, ran 2.** Both PARTIAL with strong structural progress; +4 axiom-clean
  declarations, 0 forced math.
- **dag-query:** gaps = 0; unmatched = 4 (1 pre-existing dead `CechAcyclic.affine` + 3 new — see
  recommendations). `sync_leanok` ran iter-053 (sha `7aada52`, +1/−0, chapter
  `Cohomology_CechHigherDirectImage.tex`). **blueprint-doctor: no structural findings.**

## Lane 1 — `cechAugmented_exact` (CechAugmentedResolution.lean): bridge WIRED, 1 residual

This was the headline of the iter. The planner's iter-052 routing handoff (relocate the theorem
to a new downstream file to break the import cycle) + D2 discharger correction (prepend-`i_fix`
homotopy, NOT the tilde/02KG cover) both held. The prover wired the **entire** site/category
bridge end-to-end and isolated the math down to a single concrete residual:

1. **Reflect** `IsZero (homology p)` through `SheafOfModules.toSheaf X.ringCatSheaf` via the new
   `isZero_of_faithful_preservesZeroMorphisms` (3-line helper, `IsZero.iff_id_eq_zero` +
   `Functor.map_injective` + `map_id`/`map_zero`; instances auto-found). ✓ axiom-clean.
2. **Transport** across `toSheaf.mapIso (homologyIsoSheafify α cc K p) ≪≫ (sheafificationCompToSheaf
   α).app P` with `α = 𝟙 X.ringCatSheaf.obj`. Compiled with **no** `change`/defeq coercion — the
   bundled-iso route dodges the `.val`/`.hom` + CommRingCat semiring diamonds. ✓
3. **Site reduction** via the new `isZero_presheafToSheaf_of_locally_isZero`: built the genuine
   covering sieve `S_U = {g : V⟶U | ∃ i, V ≤ coverOpen 𝒰 i}`, shown `∈ Opens.grothendieckTopology X U`
   from `Scheme.OpenCover.iSup_opensRange` (`⨆ᵢ coverOpen = ⊤`). ✓
4. **Evaluation-at-V preserves homology**: `GV = toPresheaf ⋙ eval(op V)` is `Additive` +
   `PreservesHomology` (`inferInstance`), so `Functor.mapHomologyIso'` rewrites the residual into the
   section complex. ✓

**The ONE residual sorry (line 180):** `IsZero (((GV.mapHomologicalComplex cc).obj Kp).homology p)`
for `V ≤ coverOpen 𝒰 i` — i.e. the augmented Čech *section* complex `Γ(V, cechAugmentedComplex 𝒰 F)`
has zero homology in every degree. This is the cover-agnostic prepend-`i_fix` contracting homotopy,
and it is **the same categorical→combinatorial bridge** (`.mapHomologicalComplex` ↔
`CombinatorialCech.depDiff`) that keeps `CechAcyclic.affine` open. ~150–250 LOC; not attempted (would
risk an unclosable mess). lvb `cechaug` confirms: the residual is the **same** gap the blueprint
Step 3/4 names — the proof has **not** diverged.

### Notable errors learned (Lane 1)
- `rw [coverOpen]` → "Failed to rewrite using equation theorems for `coverOpen`". Fix:
  `have htop : (⨆ i, coverOpen 𝒰 i) = ⊤ := Scheme.OpenCover.iSup_opensRange 𝒰; rw [htop]`.
- Universe fight on `isZero_presheafToSheaf_of_locally_isZero`: forcing `[Category.{u} C]` →
  "stuck at solving universe constraint" (Opens X hom-universe is 0). Fix: keep `C : Type*` and pass
  `[HasSheafify J AddCommGrpCat.{u}] [J.WEqualsLocallyBijective AddCommGrpCat.{u}]` as instance binders.
- `Subsingleton (Z.obj x)` synthesis failed → provide explicit `hZobj : ∀ x, IsZero (Z.obj x)` via
  `change IsZero (AddCommGrpCat.of PUnit)` + `AddCommGrpCat.isZero_of_subsingleton`. Use `change` not
  `show` (style linter). `Subsingleton.elim` closes the coercion eqns — auditor confirms **no**
  kernel-soundness (subsingleton-coherence) trap.

## Lane 2 — open-immersion pushforward (OpenImmersionPushforward.lean): foundation laid, 3 bridges remain

New file (planner D3). The prover landed the geometric foundation axiom-clean and upgraded both
scaffold bodies from bare `sorry` to real partial reductions:

- **`isAffineHom_of_affine_separated`** (private, axiom-clean): an open immersion of an affine `U`
  into a separated `X` is an affine morphism, via `IsAffineHom.of_comp j (terminal.from X)`
  (`j ≫ terminal.from X = terminal.from U` is affine since `U` is affine; `terminal.from X` is
  separated). Gives `IsAffineHom.isAffine_preimage` (`j⁻¹V` affine for affine `V`).
- **`higherDirectImage_openImmersion_acyclic`** (PARTIAL): genuine reduction `IsZero.of_iso _
  (higherDirectImage_iso_sheafify_presheafHomology …)` narrows the goal to
  `IsZero (sheafification(𝟙).obj (presheaf-homology q))`; residual sorry (line 87).
- **`higherDirectImage_openImmersion_comp`** (PARTIAL): only `haveI : IsAffineHom j` + a comment
  decomposition; all three categorical building blocks (`PreservesFiniteLimits`/`Additive`
  pushforward, `pushforwardComp`) verified present via `lean_multi_attempt`; sorry (line 128).

Both bottom out on the **same three unbuilt bridges** (genuine, ~60–150 LOC each):
(1) **cohomology-presheaf identification** `(pushforwardResolutionPresheafComplex j I).homology q ≅
(V ↦ Hᵠ(j⁻¹V, H))` — *this is the hand-off step already deferred upstream in
`HigherDirectImagePresheaf.lean`*; (2) **Serre-vanishing transport to a general affine open**
(`affine_serre_vanishing` lives on `Spec R`, `j⁻¹V` is an affine open *subscheme*); (3) a
**`PresheafOfModules.sheafification` locally-zero site lemma** (existing site lemmas target
`presheafToSheaf J A`, not `PresheafOfModules.sheafification α`).

## Subagent findings (full reports linked; act-on items in recommendations.md)
- **lean-auditor `iter053`** (`task_results/lean-auditor-iter053.md`): 3 must-fix (= the 3 expected
  sorries, not new defects) / 2 major / 3 minor. **Confirmed both new completed helpers are
  axiom-clean and kernel-sound; NO subsingleton-coherence trap.** Major non-sorry findings:
  (a) **docstring misattachment** — `OpenImmersionPushforward.lean:50–62` docstring (describing the
  higher-direct-image vanishing theorem) is parser-attached to the private `isAffineHom_of_affine_separated`
  at line 63 instead of `higherDirectImage_openImmersion_acyclic` at line 71; (b) **overclaiming
  comment** at line 111 ("all categorical building blocks below are verified to exist") inside a body
  that reduces to `sorry`.
- **lean-vs-blueprint `cechaug`** (`task_results/lean-vs-blueprint-checker-cechaug.md`): architecture
  faithful, NOT diverged; residual sorry = the blueprint's named gap. Major: both new helpers
  **uncovered** (no `\lean{}`); blueprint Step 3/4 does **not** name the `cechAugmentedComplex`-sections
  ↔ `FreePresheafComplex` transport route the prover needs to close the sorry.
- **lean-vs-blueprint `openimm`** (`task_results/lean-vs-blueprint-checker-openimm.md`): 4 must-fix —
  2 sorry bodies, the **`Nonempty (A ≅ B)` return-type weakening** of `higherDirectImage_openImmersion_comp`
  (blueprint claims a canonical `A ≅ B`; not a protected signature, so changeable), and the blueprint
  proof sketch leaving the 3 bridges unnamed (under-specified).

## Low-severity notes
- Two `/- Planner strategy: … -/` blocks in production source (CechAugmentedResolution:108–128,
  OpenImmersionPushforward:37–48) — internal iteration noise, harmless, should be condensed before
  any submission (prover-domain; not blocking).
- `OpenImmersionPushforward.lean:65` `have hg : IsSeparated (terminal.from X)` may be redundant if
  instance-synthesizable from `[X.IsSeparated]` (low risk, dead-code-only).

## Blueprint markers updated (manual)
- None this iter. No Mathlib re-export was added (all 4 new completed decls are project-proved, so no
  `\mathlibok`); no prover rename to correct in any `\lean{...}`; no stale `\notready` on a now-existing
  block. The two new completed helpers are *uncovered* (no blueprint block at all) — that is 1-to-1
  coverage debt for the **planner/blueprint-writer** to author prose for, not a marker edit (listed in
  recommendations.md). The deterministic `sync_leanok` added 1 `\leanok` this iter
  (`Cohomology_CechHigherDirectImage.tex`, sha `7aada52`).
