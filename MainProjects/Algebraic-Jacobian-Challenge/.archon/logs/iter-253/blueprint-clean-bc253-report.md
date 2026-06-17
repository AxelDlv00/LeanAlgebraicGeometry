# Blueprint-clean report — bc253

**Chapter:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Pre-existing false-positive
The `\begin{lemma}` at line 1632 inside the `% SOURCE QUOTE:` comment of
`lem:tensorobj_inverse_invertible` causes a lemma-environment imbalance
(82 begins, 81 ends). This is pre-existing (confirmed by `git stash` recount)
and left untouched per directive.

---

## Block 1 — `lem:pullback_tensor_map_natural` proof (D1′ fourth-square)

**Stripped:**

1. Lean declaration name `\(\mathtt{Functor.OplaxMonoidal.}\delta\mathtt{\_natural}\), valid for any oplax monoidal functor` replaced with "this holds for any oplax monoidal functor."

2. Lean tactic-recipe clause removed:
   > "in this distribution the carrier of the sheaf appears in two spellings —
   > `\mathtt{Sheaf.val}` and the forgetful image along
   > `\_ ∘ \mathtt{forget}_2 \mathtt{CommRingCat} \mathtt{RingCat}` —
   > which are definitionally but not syntactically equal, so the distribution is
   > carried out by definitional-keyed rather than head-keyed rewriting."
   The surrounding clause was rewritten to "agree on the nose but whose syntactic
   mismatch prevents the interchange law from bridging between them."

3. Jargon phrase "instance-free, element-level identity on `(M ⊗_X N).obj U`" removed;
   replaced with plain prose pointing to the sectionwise identity.

4. Lean accessor equations replaced with standard math notation:
   - Old: `p.app U ∘ η_{M'}.app U = η_M.app U ∘ (f^*a).val.app U`
   - New: `p_U ∘ (η_{M'})_U = (η_M)_U ∘ (f^*a)_U`

5. `% NOTE (iter-253)` comment (6 lines, whisker-exchange blocking note) dropped —
   the prose now stands on its own.

**Mathematical content preserved:** fourth square reduces to bilinear sectionwise
η-naturality; the route via `PresheafOfModules.Hom.ext` + `ModuleCat.hom_ext` +
`TensorProduct` induction is retained.

---

## Block 2 — `lem:sheafify_tensor_unit_iso_natural` (new statement-only block)

**Stripped:**

- "`\mathtt{ModuleCat}` components" → "module components" (one occurrence, line ~3354).

**LaTeX validity:** `\begin{lemma}...\end{lemma}` balanced, `\label`, `\lean` well-formed,
no `\uses` (statement-only block, correct).

---

## Block 3 — `lem:pullback_val_iso_natural` (new statement-only block)

**No changes needed.** Block was already math-pure with no tactic leakage.
`\begin{lemma}...\end{lemma}` balanced, `\label`, `\lean` well-formed.

---

## Block 4a — `lem:scheme_modules_hom_local_section` (new statement-only block)

**Stripped:**

1. `M.\mathtt{val}.\mathtt{presheaf}` and `N.\mathtt{val}.\mathtt{presheaf}` (Lean field
   accessors) removed; rewritten as "the sheaf of abelian-group morphisms from the
   underlying presheaf of M to that of N (i.e. `\mathtt{presheafHom}` of the two
   underlying presheaves of abelian groups)."

2. `\mathcal{H}.\mathrm{obj}\,(\mathrm{op}\,U_i)` (Lean functor application notation) →
   `\mathcal{H}(U_i)`.

3. "naturality field" (Lean struct-field jargon) → "naturality condition."

4. `\mathtt{Over}\,U_i` (Lean slice-category name) → "the slice category over U_i."

5. `\mathtt{Opens}\,X` → "the thin poset of opens of X."

**Mathematical content preserved:** eqToHom-conjugation, thin-poset Subsingleton.elim
coherence, section-direction slice of `lem:open_immersion_slice_sheaf_equiv`.

---

## Block 4b — `lem:sheafofmodules_hom_of_local_compat` proof, sub-step (a)

**Stripped:**

1. `% NOTE (iter-253)` comment (4 lines, localSection pinning note) dropped.

2. "standalone axiom-clean lemma" → "standalone lemma" (project-history jargon).

3. "naturality field" → "naturality condition" (two occurrences in the surrounding
   step (i) paragraphs).

4. Lean variable name `hf` (three occurrences):
   - "The hypothesis `hf` is phrased" → "The overlap-agreement hypothesis is phrased"
   - "`hf`'s heterogeneous agreement" → "the heterogeneous agreement"
   - "`hf`'s `\mathtt{HEq}` becomes" → "the heterogeneous agreement becomes"

5. `\(\mathtt{IsCompatible}\,\mathcal{H}.1\,U\,(\mathtt{localSection}\,U\,f)\)` (full
   Lean application with `.1` field accessor) → `\(\mathtt{IsCompatible}\)`.

6. `\(\mathcal{H}.1.\mathrm{obj}\,(\mathrm{op}\,(U_i \sqcap U_j))\)` (two occurrences,
   `.1` field accessor + `.obj(op(...))`) → `\(\mathcal{H}(U_i \sqcap U_j)\)`.

7. "(its `\mathrm{app}` and naturality fields" (Lean NatTrans struct-fields) →
   "(its sectionwise components and naturality."

8. `M.\mathtt{val}.\mathtt{presheaf}` and `N.\mathtt{val}.\mathtt{presheaf}` in step (i)
   intro and step (b) removed; rewritten as "the underlying presheaves of abelian groups
   of M and N."

9. `\mathcal{H}.\mathrm{obj}\,(\mathrm{op}\,U_i)` in step (i) → `\mathcal{H}(U_i)`.

**Mathematical content preserved:** HEq → IsCompatible bridge via eqToHom-transport and
Subsingleton.elim thin-poset uniqueness; the four sub-step structure (a)–(d) retained.

---

## Block 5 — `lem:dual_unit_iso` (polished proof + dropped \uses)

**No changes needed.** Proof prose was already math-pure (evaluation at 1, scalar-action
isomorphism, no Lean-specific leakage). LaTeX valid.

---

## LaTeX validity summary

| Environment | begins | ends | balanced |
|-------------|--------|------|----------|
| lemma       | 82     | 81   | no (pre-existing comment false-positive at L1632) |
| proof       | 62     | 62   | yes |
| definition  | 16     | 16   | yes |
| remark      | 3      | 3    | yes |

All `\label`, `\lean`, `\uses`, `\cref` in the four edited blocks are well-formed.
No `\leanok`/`\mathlibok` markers touched.
