import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/core/colors.dart';

class FilterWidget extends StatelessWidget {
  final TaskCategory? selectedCategory;
  final TaskPriority? selectedPriority;
  final TaskSortOption sortOption;
  final Function(TaskCategory?) onCategoryChanged;
  final Function(TaskPriority?) onPriorityChanged;
  final Function(TaskSortOption) onSortChanged;
  final Function() onClearFilters;

  const FilterWidget({
    Key? key,
    required this.selectedCategory,
    required this.selectedPriority,
    required this.sortOption,
    required this.onCategoryChanged,
    required this.onPriorityChanged,
    required this.onSortChanged,
    required this.onClearFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filters & Sort",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (selectedCategory != null || selectedPriority != null)
                TextButton(
                  onPressed: onClearFilters,
                  child: Text(
                    "Clear All",
                    style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),

          Text(
            "Sort By",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: TaskSortOption.values.length,
              itemBuilder: (context, index) {
                final option = TaskSortOption.values[index];
                final isSelected = sortOption == option;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(option.displayName),
                    selected: isSelected,
                    onSelected: (selected) => onSortChanged(option),
                    backgroundColor: Colors.grey[200],
                    selectedColor: AppColors.appBarColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),

          Text(
            "Priority",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: TaskPriority.values.length + 1,
              itemBuilder: (context, index) {
                TaskPriority? priority;
                String label = "All";
                
                if (index == 0) {
                  priority = null;
                } else {
                  priority = TaskPriority.values[index - 1];
                  label = priority!.displayName;
                }
                
                final isSelected = selectedPriority == priority;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) => onPriorityChanged(priority),
                    backgroundColor: Colors.grey[200],
                    selectedColor: priority != null ? _getPriorityColor(priority) : AppColors.appBarColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),

          Text(
            "Category",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: TaskCategory.values.length + 1,
              itemBuilder: (context, index) {
                TaskCategory? category;
                String label = "All";
                
                if (index == 0) {
                  category = null;
                } else {
                  category = TaskCategory.values[index - 1];
                  label = category!.displayName;
                }
                
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) => onCategoryChanged(category),
                    backgroundColor: Colors.grey[200],
                    selectedColor: AppColors.appBarColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}
