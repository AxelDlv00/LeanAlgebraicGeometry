# Blueprint-writer directive — FBC crux decomposition (slug: fbc-decomp)

## Chapter to edit
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (ONLY this file).

## Strategy context (the slice that matters)
FBC-A proves the i=0 affine base-change pushforward iso directly on global sections. The two open
cruxes are the section-level adjoint-mate computation. Two iters of prover work (iter-004, iter-006)
established hard facts that the current blueprint proof prescriptions CONTRADICT — they must be
corrected, and one of them decomposed, before the prover is re-dispatched in iter-008.

## TASK 1 — [must-fix] Rewrite the proof of `lem:base_change_mate_regroupEquiv` (statement block at
L1228–1259; proof block at L1261–1309).

The current proof block prescribes obtaining the `ModuleCat` iso "directly from the standalone
R'-linear equivalence `base_change_regroup_linearEquiv` by `LinearEquiv.toModuleIso`; the separate
compilation unit normalises the `Module A (A ⊗_R R')` instance diamond so the bundled `map_smul'`
discharges." **This prescription is mathematically UNSOUND for the current Mathlib pin and was
definitively refuted by the iter-006 prover.** The refutation (keep this reasoning; encode it as the
new proof rationale, not as a NOTE):

- The helper `base_change_regroup_linearEquiv`'s source `(A ⊗[R] R') ⊗[A] M` tensors over the
  CANONICAL `Algebra.TensorProduct.leftAlgebra` A-action on `A ⊗[R] R'`, whereas the object carrier
  `(extendScalars includeLeftRingHom).obj M` tensors over the `restrictScalars includeLeftRingHom`
  A-action. The A-module is an *instance argument of `TensorProduct`*, so these are DIFFERENT TYPES
  — not defeq even across the import boundary. Separate compilation normalises the value-level
  `Module A` diamond but NOT the two tensor TYPES. Hence the identity-A-linear bridge `eT` between
  the two A-actions is mathematically essential; it cannot be eliminated.
- The genuine residue is then the `R'`-linearity (`map_smul'`) of the assembled additive equivalence
  `g`. The obstruction is an opaque-instance wall: the `Module R'` structure on the
  source/target carriers is only available via `letI := inferInstanceAs (Module R' …)`, which
  compiles to an opaque aux-def, so typeclass search cannot derive `SMulZeroClass R' …` / `DistribSMul`
  through it and the standard smul-reduction lemmas do not fire.

**Replace the proof block with a sound, formalizable prescription.** The viable route the prover
identified (lemmas all confirmed present in Mathlib at this pin): prove `map_smul'` by
`TensorProduct.induction_on` on the generator, threading the R'-action through a TRANSPARENT instance
so the reduction chain fires:

  `ModuleCat.restrictScalars.smul_def` (object R'-action: `r' • y = (1 ⊗ r') • y`)
    → `ModuleCat.ExtendScalars.smul_tmul` (`s • (s' ⊗ₜ m) = (s*s') ⊗ₜ m` on the extendScalars carrier)
    → `Algebra.TensorProduct.tmul_mul_tmul` (`(1⊗r')*(a⊗s) = a⊗(r'*s)`)
    → then the helper's `comm` / `cancelBaseChange_tmul` / `comm` simp set to land on `r' ⊗ m`.

State in the proof prose, as the recommended formalization path, EITHER of the two routes the prover
named (pick the one you judge cleaner and present it as primary, mention the other as a fallback):
  (a) a `TensorProduct.ext`-style linearity check that keeps the generator `(a ⊗ₜ s) ⊗ₜ m` typed at
      the FULL object throughout (so `smul_def`/`smul_tmul` fire against the object's own R'-instance,
      not an opaque `letI`); OR
  (b) introduce a project-local `ModuleCat`-level base-change iso for the mixed
      `restrictScalars ∘ extendScalars` square (Beck–Chevalley style) as a small standalone helper,
      which keeps generators typed at the object and exposes a transparent `Module R'` instance.
If you choose (b), add a SHORT standalone helper lemma block for that ModuleCat base-change iso, with
its own `\label`, `\lean{}` (a fresh name, e.g. `AlgebraicGeometry.base_change_mate_regroupEquiv_smul`
or a ModuleCat-square iso name), and a one-line informal proof, and wire `\uses{}` accordingly — so
the prover formalizes a small, well-typed piece rather than fighting the opaque instance inline.

Keep the existing SOURCE/SOURCE QUOTE (Stacks "Affine base change", "boils down to the equality")
and the tensor-order convention NOTE. Keep the statement block unchanged (the signature is correct).

## TASK 2 — [major] Decompose `lem:base_change_mate_generator_trace_eq` (statement L1311–1341;
proof L1343–1379) into THREE named sub-lemmas.

The monolithic per-generator identity `(Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)(1 ⊗ x) = regroupEquiv.inv (1 ⊗ x)`
is Mathlib-absent and cannot be closed whole; the iter-006 prover landed the `ext x` reduction but
could not close the residual. Split the existing 3-step trace (the itemized (1)/(2)/(3) in the proof)
into three sub-lemma blocks, each with `\label`, `\lean{}` (fresh names), `\uses{}`, a focused
statement, and a short informal proof. Suggested decomposition (use these as the seam; refine names):

- **Sub-lemma A — unit value.** `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (or similar):
  the `((g')^*,(g')_*)`-unit η' on the global A-module `M`, read through `Θ_tgt`
  (Lemma `base_change_mate_codomain_read`), sends a generator `m ↦ (1 ⊗ 1) ⊗ m`. This identifies the
  `pullbackPushforwardAdjunction g'` unit's component at `tilde M` via `pullback_spec_tilde_iso`
  naturality at the unit.
- **Sub-lemma B — (g^*⊣g_*) transpose formula.** `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}`:
  the `(g^* ⊣ g_*)`-transpose (for ψ) of an R-linear map `u : restr_φ M → restr_ψ N` is the unique
  R'-linear `û : R' ⊗_R M → N` with `û(r' ⊗ m) = r' · u(m)`. Applied to `u = (m ↦ (1⊗1)⊗m)` this
  gives `r' ⊗ m ↦ r' · ((1⊗1) ⊗ m) = (1 ⊗ r') ⊗ m` (the R'-action scales the R'-factor). This is
  the standard adjunction-transpose-on-elements formula, isolated as the Mathlib-absent plumbing.
- **Sub-lemma C — pseudofunctor reindex.** `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}`:
  the step-(2) reindex — `f_* = restrictScalars φ` leaves `m ↦ 1 ⊗ m` unchanged on elements and the
  pseudofunctor identities `(g'f)_* = (f'g)_* = g_* f'_*` reindex the target as the codomain read.
  Note (carry as a prose remark): the prover expects this step to close by the existing in-file
  category API (`pushforwardComp`, `pushforwardCongr` naturality) once A and B are isolated.

Then REWRITE the proof of `lem:base_change_mate_generator_trace_eq` to be a thin assembly: invoke
sub-lemmas A, C, B in sequence to obtain `r' ⊗ m ↦ (1 ⊗ r') ⊗ m = (r'⊗1)⊗m` and conclude it equals
`regroup⁻¹` on generators, hence everywhere by R'-linearity. Wire `\uses{}` on the assembly to the
three new sub-lemma labels (plus the existing domain/codomain reads). Keep the SOURCE/SOURCE QUOTE.

## References
The chapter already cites Stacks "Affine base change". You MAY consult
`references/stacks-coherent.tex` (the "boils down to the equality" passage, ~L933–938) if you need to
re-read it. The adjunction-transpose-on-elements formula (Sub-lemma B) is standard category theory
(the `(g^* ⊣ g_*)` = base-change adjunction); no new reference needed, but if you want a citation
anchor for the base-change adjunction unit formula, you may add a `% NOTE:` rather than a fake SOURCE.

## Out of scope
- Do NOT touch any other declaration in the chapter (the 25 closed lemmas, `affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso`).
- Do NOT add `\leanok` to anything (the deterministic sync owns it).
- Do NOT edit any `.lean` file or any other chapter.
- The new sub-lemma `\lean{}` names are NEW Lean declarations that do not yet exist — that is expected;
  the prover will create them next iter. Just give them precise, well-formed statements and `\uses{}`.

## Report
List every block you added/rewrote with its label and `\lean{}` name, and confirm the `\uses{}` graph
is consistent (assembly → sub-lemmas → domain/codomain reads). Flag any strategy-modifying finding.
