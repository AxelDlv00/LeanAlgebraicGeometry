# Blueprint-writer directive — bw253

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (consolidated chapter; `% archon:covers`
lists both `Picard/TensorObjSubstrate.lean` and `Picard/TensorObjSubstrate/DualInverse.lean`).

You are making THREE targeted corrections flagged by the iter-252 Lean↔blueprint checkers
(`task_results/lean-vs-blueprint-checker-ts252.md`, `task_results/lean-vs-blueprint-checker-di252.md`).
Do NOT touch any other block. Do NOT add/remove `\leanok`/`\mathlibok` markers (the deterministic
`sync_leanok` phase owns `\leanok`; the review agent owns `\mathlibok`). Do NOT delete the existing
`% NOTE (iter-252)` comments — fold their content into the prose, then you may leave or trim them.

### FIX 1 (MUST-FIX) — correct the D1′ proof sketch: the whisker-exchange route is BLOCKED in Lean

Block: `\begin{proof}` of `\label{lem:pullback_tensor_map_natural}`
(`\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}`), around lines 3310–3340.

The current proof's **fourth-square paragraph** (≈ lines 3323–3328) ends with:
> "The fourth square — the naturality of `sheafifyTensorUnitIso` — reduces, once the comparison is
> expanded into its whisker factors, to the naturality of the sheafification unit η in each tensor
> argument …, the middle crossings being resolved by the monoidal interchange (whisker-exchange) law."

This is **mathematically misleading for the formalization**: the whisker-exchange route does NOT
close the step in Lean. The reason (verified live by the iter-252 prover via `lean_multi_attempt`):
the η-whiskers and the `tensorHom`-expanded factors carry two DIFFERENT monoidal-structure instances
(`PresheafOfModules.monoidalCategoryStruct` vs `monoidalCategory.toMonoidalCategoryStruct`) that are
definitionally equal but NOT syntactically equal, so the whisker-exchange lemmas
(`whisker_exchange`, `comp_whiskerRight`, `whiskerLeft_comp`) fire only within a single instance
group and cannot bridge the cross-group crossing.

**Rewrite the fourth-square paragraph** to describe the route that actually works (and is committed +
compiling in Lean), namely the **section-level descent to elements**:

- The naturality of `sheafifyTensorUnitIso` is checked by descending to sections: apply the
  extensionality principle for presheaf-of-modules morphisms (`PresheafOfModules.Hom.ext`) to reduce
  the square to an equality of components over each open `U`.
- Over `U`, unfold the whiskers to honest `tensorHom`s and distribute the comparison's legs into
  concrete `ModuleCat` maps (the carrier-spelling friction — `Sheaf.val` vs the forgetful
  `_ ⋙ forget₂ CommRingCat RingCat` — means the distribution is done by definitional-keyed rewriting,
  not head-keyed rewriting; this is engineering detail, mention it only as "the two carrier spellings
  are defeq-not-syntactic").
- After `ModuleCat.hom_ext` the goal is an **instance-free element-level identity** on the tensor
  product `(P ⊗ Q).obj U`, closed by `TensorProduct` induction: on a pure tensor `p ⊗ q` it is the
  sectionwise naturality of the sheafification unit η in each argument separately —
  `p.app U ≫ η_{P'}.app U = η_P.app U ≫ (f^*p).val.app U` and the analog for `q` — combined.

State this at the same textbook level as the surrounding prose (no Lean tactic strings beyond the
named principles `PresheafOfModules.Hom.ext`, `ModuleCat.hom_ext`, `TensorProduct` induction, which
are acceptable as "the formalization proceeds by …" signposts). The mathematical content is: the
fourth square reduces to the bilinear, sectionwise naturality of η, verified one pure tensor at a time.

The helper that carries this fourth-square sorry is the Lean declaration
`AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_natural`.

### FIX 2 (add `\lean{}` pins for three substantive helpers)

Add `\lean{...}` tags so the dispatch frontier tracks these. Either add them to the relevant existing
proof body as `\lean{}` lines, or (cleaner) introduce a thin `\begin{lemma}` / `\begin{definition}`
stub block with `\label`, `\lean`, a one-sentence statement, and a `\uses` where natural:

1. `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_natural` — the section-level naturality
   helper that gates D1′ (the fourth square of FIX 1). Suggested label `lem:sheafify_tensor_unit_iso_natural`.
2. `AlgebraicGeometry.Scheme.Modules.pullbackValIso_hom_natural` — a CLOSED axiom-clean helper
   (naturality of the `pullbackValIso` comparison; square 4 input to D1′). Suggested label
   `lem:pullback_val_iso_natural`.
3. `AlgebraicGeometry.Scheme.Modules.homLocalSection` — the load-bearing local-section sub-lemma the
   chapter already names `localSection` throughout the `lem:sheafofmodules_hom_of_local_compat` proof.
   It is now CLOSED axiom-clean. Pin it (suggested label `lem:scheme_modules_hom_local_section`), and
   in the `homOfLocalCompat` proof prose replace the informal name `\mathtt{localSection}` with a
   `\cref{}` to this new block (keep the prose readable).

### FIX 3 (MAJOR — expand the HEq → IsCompatible bridge in `homOfLocalCompat`)

Block: `\begin{proof}` of `\label{lem:sheafofmodules_hom_of_local_compat}`, sub-step (a), around
lines 5706–5709. Current prose: "(a) the cocycle/`IsCompatible` condition … which is exactly the
assumed agreement of `f_i` and `f_j` on the overlaps `U_i ∩ U_j`." This is the EXACT remaining sorry
and the prose gives no path. Expand it into a concrete recipe (this is the one piece the prover needs):

- The hypothesis `hf` is stated with `HEq` (heterogeneous equality) because the two double-restrictions
  `(f_i)|_{U_i ∩ U_j}` and `(f_j)|_{U_i ∩ U_j}` live in propositionally-equal-but-not-definitionally-equal
  types (the two slice-restriction routes to `U_i ∩ U_j`).
- `IsCompatible H.1 U (homLocalSection U f)` asks instead for an equality of the two restrictions of the
  local sections `homLocalSection i` and `homLocalSection j` to the overlap, as honest sections of the
  hom-sheaf `H` over `U_i ⊓ U_j`.
- The bridge: transport `hf`'s `HEq` agreement through the `eqToHom`-conjugation built into
  `homLocalSection` (its `app`/`naturality` fields), using that any two parallel morphisms in the thin
  poset `(Opens X)ᵒᵖ` are equal (`Subsingleton.elim`) to collapse the route-difference. Concretely:
  restricting `homLocalSection i` to the overlap evaluates (sectionwise) to the component of `f_i`
  conjugated by `eqToHom`s, and likewise for `j`; the `HEq` in `hf` becomes a genuine equality once
  both sides are transported to the common type `H.1.obj (op (U_i ⊓ U_j))` via those `eqToHom`s and
  `Subsingleton.elim` identifies the comparison maps.

Keep sub-steps (b), (c), (d) as they are (they are already adequately described). You may trim the
`% NOTE (iter-252)` comment at ~5682–5689 once its content is folded into the prose.

### Optional polish (MINOR — only if quick)
- `lem:dual_unit_iso` proof `\uses{}` lists `lem:tensorobj_unit_iso`, but the Lean route
  (`unitDualSectionEquiv` via `globalSMul` inverse) does not use the left-unitor. Either drop that
  `\uses` entry or add a one-line note that the Lean route is the direct eval-at-1/`globalSMul` one.

## Citation discipline
These are all Archon-bespoke formalization-engineering corrections (carrier-friction routing,
gluing bookkeeping) with NO new external source claim. Do NOT add `% SOURCE:` / `% SOURCE QUOTE:`
lines — the existing source citations on these blocks stay as-is. You are only correcting the
project's own proof-route prose to match what the Lean formalization actually does.

## Out of scope
Do NOT edit any block outside the three FIXes above. Do NOT touch the D2′ telescope blocks
(they are CLOSED and correct). Do NOT touch `dual_restrict_iso` Step-4 prose (it is an accurate
frontier description). No marker edits.

## Report
List each block you edited (label + what changed) and confirm no markers were touched. If you find
you need a source you don't have, you are authorized to spawn a `reference-retriever` (your
write-domain includes `references/**`), but FIX 1–3 should need none.
