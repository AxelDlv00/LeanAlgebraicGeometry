# Blueprint Writer Directive — FBC route swap (dissolve the adjoint-mate tower)

## Slug
fbc-routeswap

## Chapters to edit
- PRIMARY: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
- SECONDARY: `blueprint/src/chapters/Cohomology_RegroupHelper.tex` (only the
  `base_change_regroup_linearEquiv` block — see §3 below)

You may also read/write `references/**` if you need to spawn a reference-retriever, but
the two sources you need (Stacks tag 02KH and the analogist's analogies file) are already
on disk — see References.

## Why this rewrite (strategy decision, already made by the plan agent)
The FBC affine-lemma route is committed to **direct-on-sections** (Stacks 02KH part 2). The
chapter's `\subsection{The section-level mate computation, decomposed}` (currently lines
~978–1793) still carries the parent's abstract **adjoint-mate tower** — three categorically
subtle, *untyped* sub-lemmas (`base_change_mate_unit_value`, `base_change_mate_fstar_reindex`,
`base_change_mate_gstar_transpose`) feeding `base_change_mate_generator_trace_eq`. A
strategy-critic CHALLENGE (iter-009) and a mathlib-analogist report (iter-009) converged: this
tower is the wrong path (it has blocked FBC-A ~6 iters and is over budget), and the route the
strategy already commits to in prose should be executed instead. Your job is to make the
blueprint match that decision. Two coordinated changes:

## §1 — Replace the mate tower with ONE section-level identity
Mathematical content (verify against Stacks 02KH part 2 before writing — see References):

The base-change map `θ : g^* f_* F → f'_* g'^* F` is the mate of `f_*` applied to the unit of
the `(g'^*, g'_*)` adjunction. In the **affine–affine** case `f = Spec(φ : R→A)`,
`g = Spec(ψ : R→R')`, `F = M~` for an `A`-module `M`, its value on global sections is precisely
the `R'`-base change of the **algebraic unit** on sections:
`Γ(θ) = lTensor R' η_M`, where `η_M : M → (A ⊗_R R') ⊗_A M`, `m ↦ 1 ⊗ₜ m` is the unit of
extension of scalars along `A → A ⊗_R R'` read on the section module, and `lTensor R'` is
`R' ⊗_R (−)`. Post-composing with the canonical regrouping iso
`(A ⊗_R R') ⊗_A M ≅ R' ⊗_R M` (the `regroupEquiv`, see §2/§3) identifies `Γ(θ)` with the
canonical base-change comparison, which is an isomorphism.

Concrete edits:
- **DROP** the three blocks `lem:base_change_mate_unit_value` (~1328),
  `lem:base_change_mate_fstar_reindex` (~1356), `lem:base_change_mate_gstar_transpose` (~1386).
  They are superseded — remove the `\begin{lemma}…\end{lemma}` and any attached
  `\begin{proof}…\end{proof}`.
- **REPLACE** `lem:base_change_mate_generator_trace_eq` (~1423) with a single new lemma
  block — suggested label `lem:base_change_mate_section_identity`, suggested
  `\lean{AlgebraicGeometry.base_change_mate_section_identity}` — stating the section-level
  identity `Γ(θ) = lTensor R' η_M` above. Give it a rigorous, formalizable `% LEAN SIGNATURE`
  block (the project convention; the prover formalizes the pinned type) over
  `(R A R' : Type*) [CommRing …]` with `φ : R →+* A`, `ψ : R →+* R'`, `M` an `A`-module,
  typed at the carriers that `lem:base_change_mate_domain_read` / `lem:base_change_mate_codomain_read`
  (which you KEEP — they read the carriers and are still needed for typing) produce. Include the
  `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source:}` citation to Stacks 02KH part 2 and a
  full informal proof (the naturality computation reducing `Γ(θ)` to `lTensor R' η_M`).
- **KEEP** `lem:base_change_mate_domain_read` (~1086) and `lem:base_change_mate_codomain_read`
  (~1133): they remain the typed reads of the two carriers and the section identity is typed
  against them.
- **UPDATE** the downstream assembly `lem:pushforward_base_change_mate_cancelBaseChange` (~1534)
  and the goal node `lem:affine_base_change_pushforward` (~1668): rewrite their `\uses{}` and
  proof prose to depend on the new `lem:base_change_mate_section_identity` +
  `lem:base_change_mate_regroupEquiv` (§2) + Mathlib `cancelBaseChange`, NOT on the dropped
  sub-lemmas or the dropped `generator_trace_eq`. If `lem:base_change_mate_generator_trace`
  (~1497) exists only as the IsIso corollary of the dropped `generator_trace_eq`, repoint it to
  the section identity (keep it if it's the IsIso wrapper the goal uses; drop it if it is now
  redundant). **No `\uses{}` may reference a dropped label** — the leandag must stay
  unbroken (0 broken \uses).
- Rewrite the prose intro of the subsection so it describes the direct section-level route, not
  the "decomposed mate" route. Rename the subsection title if appropriate (e.g. "The
  section-level base-change identity").

## §2 — Fix `lem:base_change_mate_regroupEquiv` (kill `map_smul'`)
The regroup iso `(A ⊗_R R') ⊗_A M ≅ R' ⊗_R M` is currently constructed hand-rolled as a
`≃ₗ[R']` whose `map_smul'` obligation hits an opaque-`Module R'`-instance wall on the
`r' • 0 = 0` branches (the iter-008 blocker). The fix (mathlib-analogist, verified): construct
it from the **natively `R'`-linear** Mathlib equiv `Algebra.IsPushout.cancelBaseChange`
(`Mathlib.RingTheory.IsTensorProduct`), whose `LinearEquiv` already bundles `R'`-linearity —
so there is NO `map_smul'`, NO `TensorProduct.induction_on`, and NO `r' • 0` zero branch. The
required `Algebra.IsPushout R R' A (A ⊗_R R')` instance is free from `TensorProduct.isPushout'`.
Rewrite the `lem:base_change_mate_regroupEquiv` block's **proof/construction prose** to describe
this construction (cite `Algebra.IsPushout.cancelBaseChange` `[verified]` and
`TensorProduct.isPushout'` `[verified]` — both confirmed present by the analogist). Keep the
statement (the iso) unchanged. Note in the prose that the residual `Module A (A⊗_R R')`
diamond against `(ModuleCat.extendScalars includeLeftRingHom).obj M` is resolved at the object
level by an identity-on-carrier `≃ₗ[R']` (`map_smul' := fun _ _ => rfl`), modelled on the
project's existing element-free `gammaPushforwardIso` coherence maps.

## §3 — `Cohomology_RegroupHelper.tex`
The Lean def `base_change_regroup_linearEquiv` (in `Cohomology/RegroupHelper.lean`) is its
underlying construction. Update the corresponding block in `Cohomology_RegroupHelper.tex` so its
construction prose reflects the `Algebra.IsPushout.cancelBaseChange` core (replacing any
description tied to `TensorProduct.AlgebraTensorModule.cancelBaseChange`, whose B-slot is `A` and
gives only `≃ₗ[A]`, forcing the dead hand-rolled `R'`-linearity). Statement (the
`(A⊗_R R')⊗_A M ≃ₗ[R'] R'⊗_R M` equiv) unchanged.

## Hard constraints
- Do NOT touch the affine-computation section (~155–710), the pullback companion (~712–815),
  the affine-base-change-lemma obligations subsection's tilde-dictionary content, or the
  FBC-B `\section{Flat base change for the pushforward}` (thm:flat_base_change_pushforward).
- Do NOT add or remove `\leanok` (the deterministic sync owns it). You MAY mark `\mathlibok`
  ONLY on a genuine Mathlib dependency anchor if you choose to author one for
  `Algebra.IsPushout.cancelBaseChange` (statement in project notation + `\lean{}` of the real
  Mathlib decl) — that is optional and good practice; never on the project's own to-be-proved
  decls.
- Every dropped label must vanish from ALL `\uses{}` in the chapter. Verify before finishing.
- Citation discipline: the new section-identity block MUST carry a verbatim `% SOURCE QUOTE:`
  from Stacks 02KH (read the local file; do not quote from memory).

## References (on disk — read before writing)
- `references/stacks-coherent.tex` (+ pointer `references/stacks-coherent.md`) — tag **02KH**,
  flat base change of `R^i f_*`; **part (2)** is the `H^0`/direct-image-with-base-change
  statement this route formalizes. Quote part (2) verbatim into the new block.
- `analogies/fbc-base-change-square-transparent-module.md` — the mathlib-analogist's full
  diagnosis: the `Algebra.IsPushout.cancelBaseChange` core swap, the diamond resolution recipe,
  and the (a)-vs-(b) rationale. This is your construction recipe for §2/§3.

## Out of scope
GF, QUOT, SNAP, GrassmannianCells chapters. FBC-B globalization. Do not invent new affine
infrastructure — the tilde dictionaries already exist and are proved.
